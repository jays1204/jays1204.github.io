---
layout: post
title:  "PostgresSQL Concurrency Create Task"
date:   2015-04-09 15:59:00
categories: encoding charset
---

# **Problem?**
현재 서비스는 node.js(0.12.0)과 postgres 9.3.5로 진행하고 있습니다.  
서비스를 살펴보던 중 의도하지 않은 상황이 발생하게 되어 postgres를 살펴보게 되었습니다.  

전제 상황은 다음과 같습니다.
> 사용자가 글을 올리 수 있는 하나의 게시물이 있습니다.
> 게시물에 사용자는 하나의 글만 올릴 수 있습니다.
> 게시물에는 최대 n개의 글이 등록가능 합니다.

위와 같은 조건을 위해 다음과 같이 service method를 구현하였습니다.  
> 1. 사용자가 글을 올리고자 하는 게시물에 대해 현재 등록된 모든 글을 가져옵니다.  
> 2. 등록된 글이 개수가 n개 이상이면 더 이상 글을 등록 할 수 없음을 알리는 에러 코드를 내려줍니다.  
> 3. 등록된 글중에 이미 사용자가 올린 글이 있다면 등록 할 수 없음을 알리는 에러 코드를 내려줍니다.  
> 4. 조건을 통과하였다면 해당 글을 게시물에 등록합니다.

이를 node.js의 step를 이용하여 구현하였습니다. 코드를 간단히 적자면 아래와 같습니다.  

```
Step(
  function _getComment() {
    db.query('SELECT * FROM post_comment WHERE post_id=$1', [id], this);
  },
  function _insertComment(err, results) {
    if (err) throw err;
    if (results.length > MAX_COUNT) throw MAX_ERR_CODE;

    results.forEach(function(el) {
      if (el.userId == user_session.userId) throw ALREADY_ERR_CODE;
    });

    db.query('INSERT INTO post_comment(...) VALUES (...) RETURNING *', this);
  }
)
```

위의 코드는 평상시에는 아무런 문제 없이 원하는 의도대로 동작을 수행합니다.  
하지만 한 사용자가 동시에 같은 글을 올리는 API를 여러번 호출한다면  원하지 않는 결과를 발생시킵니다.  

```
async.map([1,2,3,4], function(idx, cb) {
  request.post({
    jar: jar,
    url: API_URL,
    form: formData
}, function(e, r) {
  r.forEach(function(res) {
    console.log('statusCode', res.statusCode);
  });
});
```

위의 코드는 한 사용자가 하나의 게시물에 같은 내용의 글을 여러번 동시에 올리는 API를 작성한 것입니다.  
원하는 결과 값은 200과 3개의 40x입니다.  
하지만 의도와는 달리 결과값은 4개의 200 입니다. 즉 모든 글이 등록되었음을 의미합니다.  
이유를 살피기 위해 우선 postgres transaction isolation 를 살펴보도록 하겠습니다.

# **PostgresSQL Transaction isolation **
Posgres는 MVCC를 통해 동작합니다.  
MVCC는 Multi Version Concurrency Control의 약자로 Data read와 Data write가 서로를 block하지 않는 것을 의미합니다.  
MVCC를 이해하기 위해 우선 Postgres에서 사용하는 transaction에 대해서 알아보도록 하겠습니다.  
postgres에서 transaction을 위해 begin과 commit을 사용하며 이 사이에 있는 query를 하나의 단위로 처리합니다.  
또한 postgres에서 모든 query는 하나의 transaction입니다.  
```
   SELECT id FROM table;
```  
위와 같은 query도 내부적으로는 다음과 같습니다.    
```
   BEGIN;  
   SELECT id FROM table;  
   COMMIT;
```
이러한 transaction들이 동시다발적으로 실행이 된다.  


transaction에 의해 발생할 수 있는 현상은 다음 3가지가 있습니다.  
> 1.  dirty read  
    - transaction이 동시에 진행되는 아직 커밋되지 않은 transaction에 의해 쓰인 data를 읽습니다. 만일 그 다른 transaction이 commit되지 않고 rollback 된다면 데이터의 불일치가 발생합니다.  
> 2.  non-repetable read  
    - trnsaction내에 같은 query를 두 번 수행하는데 그 사이에 다른 transaction에서 값을 변경하여 두 query가 결과가 다르게 나타납니다.  
> 3.  phantom read
    - transaction 에서 같은 쿼리를 두 번 수행하였을때 첫번째에서는 없던 record가 두번째에서는 생긴 것을 말합니다.  


isolation level은 총 4가지가 있으며 각 level마다 발생가능한 현상음 다음과 같습니다.
> 1. read uncommited (postgres에서는 2와 동일함)  
    - Possible: dirty read, non-repetable read, phantom read  
> 2. read commited(default)  
    - Possible: non-repetable read, phantom read  
> 3. repeatable read  
    - Possible: phantom read(postgres에서는 불가)  
> 4. serializable  
    - Possible : nothing

현재 Database의 isolation level을 알기 위해서는 다음의 query를 이용합니다.  
```
SELECT current_setting('transaction_isolation');
```

현재 제가 사용하고 있는 DB는 default인 read commited입니다. 따라서 transaction을 걸더라도 dirty read가 발생하지 않기때문에 문제는 해결되지 않습니다. 물론 이전보다 중복으로 입력되는 글의 수는 줄어들 수 있습니다.  

이를 해결하기 위한 가장 쉬운 방법은 바로 TABLE LOCK입니다.  
ACCESS EXCLUSIVE LOCK은 SELECT query를 지정된 table에 대해 block합니다. 따라서 하나의 transaction이 수행되는 동안 첫 시작인 SELECT query가 대기해야 하므로 중복 글 등록 이슈가 사라집니다.  
하지만 table에 대한 다른 transaction들의 SELECT query가 그 동안 block되므로 data조회가 되지 않습니다.

더 쉬운 방법은 constraint 추가입니다.  
```
ALTER TABLE table_name ADD CONSTRAINT unique_post UNIQUE(col1, col2);
```  
이를 통해 사용자는 게시물 당 하나의 글만을 올리도록 제한할 수 있습니다.  

게시물의 최대 글 수 역시 before insert trigger를 통해 해결 할 수 있습니다.

- 마무리  
처음에 살펴보았던 postgres의 transaction에 대해서는 아무런 solution을 찾을 수 없었지만 배운 것은 혼자하는 것보다 물어보는게 낫다입니다.


# 참조 
- https://devcenter.heroku.com/articles/postgresql-concurrency
- http://www.postgresql.org/docs/9.3/static/transaction-iso.html
- http://blog.daum.net/sauer/14
