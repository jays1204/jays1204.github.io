---
layout: post
title: " Index "
date: 2022-03-14 12:40:00
categories: mysql, index
---

요새 DB 관련이야기를 많이 보고 질문도 받아서 공부한걸 정리했다.  
DB는 언제봐도 어렵고 새롭다. 

# Single Column vs Multi Column
빠른 검색을 위해 인덱스를 생성한다. 어떤 경우에 단일 칼럼으로 구성된 인덱스를 만들고 어떤 경우에는 여러개의 칼럼으로 구성된 인덱스를 만들까?  

- Multi Column  

여러개의 칼럼으로 구성된 인덱스는 다음과 같은 경우를 위해 사용한다.   
Where절에 A = ?, B =? , C =?  으로 조건이 걸려있을때다.   
이렇게 여러가지 칼럼에 대해 조건을 걸어두고 검색을 빠르게 하고자 할때 여러 개의 칼럼으로 구성된 인덱스를 생성하여 사용한다.   
다만 예상하다시피 이렇게 인덱스를 구성하는 요소가 많아질수록 인덱스 저장을 위한 disk 사용량이 증가, 그리고 table의 row 최신화(insert, update, delete)마다 index를 새로고침하기 위해 비용이 수반되는 점을 고려해야한다.    
그리고 여러 칼럼으로 구성된 인덱스 생성시의 칼럼 순서가 중요한데 특히 첫번째 칼럼이 중요하다. 
첫번째로 선언된 칼럼이 where 절에 등장한다면 해당 index를 사용할 수 있다. 하지만 첫번째로 선언된 칼럼이 where절에 없다면 해당 인덱스를 사용할 수 없다.
참고로 mysql의 query planner는 where 에 있는 칼럼의 순서는 신경쓰지 않는다.

만일 C1, C2로 구성된 인덱스, C1, C3로 구성된 인덱스 이렇게 C1이 중복되는 인덱스가 있다면 이럴땐 C1, C2, C3로 구성된 인덱스 하나 만드는게 더 효과적일 수 있다. 두개의 인덱스를 업데이트하는 비용을 줄이는 것이다.  

- Single Column   

하나의 칼럼으로 구성된 인덱스다. 
where 절에 하나의 칼럼에 대한 조건이 들어갈때 많이 쓰인다. 


# Cardinality
칼럼의 cardinality가 높다는 해당 칼럼을 구성하는 값들에 대해 중복의 빈도가 낮다는 것을 의미한다. 인덱스를 걸때 어떤 칼럼을 걸어야 효과가 좋을지 고민한다면 이 지표가 도움이 될 수 있다. cardinality가 높은, 즉 중복도가 낮은 칼럼일수록 인덱스 성능이 좋다.  여러개의 칼럼으로 구성된 인덱스를 만들때도 cardinality가 높은순으로 명시하면 성능 향상에 도움이 된다. 


# like ON index
like를 사용해도 index를 사용할 수도 있다.   
조건의 칼럼이 다음과 같이 %가 아닌 문자로 시작하면 인덱스를 타게된다.  

```sql 
select * from student where city like 'ci%';
```

하지만 아래와 같이 %로 시작하게 되면 인덱스를 타지 않는다. 

```sql
explain select * from student where city like '%t';
```

%로 시작하면 b-tree로 구성된 index에서 처음에 어느 node로 가야할지 알 수 없기 때문이다.  


# Clustered Index vs NonClusteredIndex
- Clustered Index  
clustered index는 테이블마다 1개가 존재하는 인덱스로 pk라고 생각하면 쉽다. pk가 없을경우이는 unique key를 사용, 아니면 숨겨진 데이터를 이용한다고 하는데 보통 이렇게까지 갈 일은 없으면 pk와 유니크 키까지만 알면되지 않을까 싶다.  
clustered index는 b+ tree로 구성되어있는데 leaf 노드에 실제 데이터를 가지고 있다.

- NonClustered Index  
Clustered index가 아닌 인덱스로 보면 된다. 
이것들은 Clustered index와 다르게 leaf 노드는 index 구성을 위해 설정한 칼럼의 데이터, 그리고 연관된 Cluster index의 키를 갖고 있고 결국에는 clustered index를 이용하게 된다.  

# Covering Index
- 커버링 인덱스는 쿼리에 있는 모든 칼럼이 clustered index를 추가적으로 검색하지 않는 것을 만족할때를 의미한다.  
즉 NonClustered Index의 leaf node에 저장된 데이터 만으로 select  결과를 뽑아낼때 covering index를 만족한다고 할 수 있다.  

```sql
CREATE TABLE `student` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `myname` varchar(30) NOT NULL DEFAULT '',
  `city` varchar(30) NOT NULL DEFAULT '',
  `age` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `test_idx3` (`city`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

```  

위와 같은 테이블이 있을때 다음 쿼리는 커버링 인덱스를 만족한다.    
```sql
select city from student;
```

city는 test_idx3에 의해 인덱스가 생성되어 있고 해당 인덱스 트리의 리프 노드를 이용하여 구성할 수 있다.  

```sql
select city, myname from student;
```

하지만 위와 같은 쿼리는 myname을 알기 위해 clustered index로 접근해야 하므로 covering index를 만족하지 않는다.  
explain 했을때 key항목에 인덱스가 선택되어있고  Extra 부분의 `using index`를 통해 covering index 여부를 알 수 있다.  

참고로 extra에는 using temporay(쿼리 실행을 위하 가상 테이블 생성), using filesort(정렬 수행) 등이 추가적으로 나타날수도 있다. using temporary 보이면 쿼리 튜닝을 하는게 좋다.


# Order By
order by할때도 인덱스가 있다면 인덱스를 사용한다.  
다만 이때는 여러개의 칼럼 인덱스일때는 인덱스의 칼럼 선언 순서가 중요하다. C1, C2, C3로 선언되어있다면 order by에서는 C1부터 차례대로 나와야 한다. order by C1, C2처럼 마지막 부분들 누락은 상관없지만 C1, C4와 같이 중간 누락은 인덱스를 사용하지 않게 된다.  
그리고 asc, desc 를 혼합해서 사용할 수 없다. 전부 asc이거나 desc여야 한다. 
인덱스를 생성할대는 mysql 8.0이전 기준으로는 전부 asc 로만 생성된다. 여러 칼럼에 대해 만들어진 인덱스 데이터는 모두 asc로 만들어졌으므로 여러개중 하나에 대해서만 다른 순서를 적용할수 없다.  
마지막으로 asc로 index생성하므로 desc로 조회시에는 backward 조회해야하므로 아무래도 asc보다 약간의 성능 저하가 있을 수 있다.  


# References
- https://stackoverflow.com/questions/2349817/two-single-column-indexes-vs-one-two-column-index-in-mysql
- https://stackoverflow.com/questions/45100174/does-order-of-columns-of-multi-column-indexes-in-where-clause-in-mysql-matter
- https://jojoldu.tistory.com/476
- https://stackoverflow.com/questions/609343/what-are-covering-indexes-and-covered-queries-in-sql-server
- https://www.red-gate.com/simple-talk/databases/sql-server/learn/using-covering-indexes-to-improve-query-performance/
