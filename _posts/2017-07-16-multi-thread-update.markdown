---
layout: post
title: " counter 구현시 동시 update 이슈 "
date: 2017-07-16 15:18:24
categories: mysql, innodb, gorm
---

## multi-thread GORM의 동시 update  
얼마전 회사에서 특정 테이블의 row들에 대한 update구문에 대한 문제가 발생하였다.  
특정 로직A는 특정 테이블의 하나의 row에 대한 카운터를 수행한다.  
기존에는 이 로직을 하나의 인스턴스에서 하나의 쓰레드로만 실행하여 문제가 되지 않았다.  
퍼포먼스 향상을 위해 이것에 멀티 쓰레드를 적용하면서 문제가 발생하였다.  

## counter 로직 A   
다음과 같은 카운터 로직 A가 있다.  

```java
begin transaction 
...
private void updateConuter(Long id) {
  Domain d = Domain.findById(id);
  d.count += 1;
  d.save();
}
...
commit transaction 
```  

이 로직은 싱글 쓰레드에서는 매우 잘 동작한다.  다만 멀티쓰레드로 실행할 경우 다음과 같은 시나리오가 생길 수 있다.  

1. 쓰레드 1과 쓰레드 2가 동시에 특정 id에 대한 row를 가져온다.  
2. 쓰레드 1, 2가 가져온 count는 10이다.  
3. 동시에 로직에 수행된 결과 count는 11이 되었다.  우리가 바란 것은 12였다.  

이와 같은 이슈가 생긴 것은 row에 대한 shared lock때문이다.  
현재 사용중인 DB는 InnoDB엔진의 MariaDB로 기본적인 isolation level인 REPEATABLE READ를 사용중이다.  
이것은 트랜잭션이 걸린 SELECT로 가져온 row에 대해 update는 막지만 SELECT는 허용한다.  
따라서 쓰레드 1과 쓰레드 2가 동시에 SELECT를 해올 수 있다. 
업데이트는 순서대로 진행할테지만 이미 가져온 counter 값이 동일 하므로 제대로된 업데이트가 되지 않았다.  

이를 해결 하기 위한 방법에는 다음의 방법들이 있다.  

## pessimistic locking
해석하자면 비관적인 락이다.  
실행하고자 하는 logic이 완료될때까지 해당 record들에 대해 lock을 걸어 접근도 하지 못하게 하여 다른 쓰레드는 대기를 하게 한다.  
이렇게 하면 우리가 원한 것처럼 순서에 맞는 count를 가져와 1씩 증가하여 알맞은 업데이트가 된다.  
다만 각 쓰레드마다 대기를 해야 하는 등의 성능 이슈가 생길 수 있다.  

```java
begin transaction 
...
private void updateConuter(Long id) {
  Domain d = sessionFactory.getCurrentSession().get(Domain.class, id, LockMode.UPGRADE);
  d.count += 1;
  d.save();
}
...
commit transaction 

```

## optimistic locking  
긍적적인 락이다.  
이것은 각 record마다 변화에 따른 버젼을 사용하여 lock을 제공한다.  
예를 들면 Domain 테이블에는 version이란 칼럼이 추가되고 이 row의 내용에 대한 checksum에 대한 version이 매겨져 있다.  
update시에 이 version을 한번 더 체크해서 이 version이 바뀌지 않았으면 업데이트를 진행하고 아니면 error를 throw한다.  
throw된 error에 대한 처리는 개발자의 고유 영역으로 남겨둔다.  

## native query  
orm이 만들어내느 쿼리가 아닌 native query를 작성하여 이를 DB에 그대로 넘겨주는 방식이다.  
InnoDB의 경우 update에 대해 row level단위의 락을 제공한다.  즉 한번에 하나의 update구문만 실행되고 나머지는 대기하였다가 실행가능한 시점에 실행이 된다.  
이를 통해 제대로 된 업데이트를 진행할 수 있고 본인은 이 방법을 사용하였다.  

# References  
- https://docs.jboss.org/jbossas/docs/Server_Configuration_Guide/4/html/TransactionJTA_Overview-Pessimistic_and_optimistic_locking.html  
- https://en.wikipedia.org/wiki/Isolation_%28database_systems%29

