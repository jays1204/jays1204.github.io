---
layout: post
title: " kafka rolling upgrade 0.9 to 0.10.2 "
date: 2017-03-15 10:58:39
categories: kafka 
---

## Kafka Upgrade
[reactor-kafka](https://github.com/reactor/reactor-kafka)를 사용하기 위해 문서를 보던 중 카프카 0.10 이상만 지원된다고 하여 기존의 0.9.0.1버젼의 카프카를 업그레이드 하기로 하였다. 

카프카 사용자 문서에 보면 데이터 손실 없이 업그레이드가 가능하다고 설명이 나와 이를 적용하였다.

### 0. 전제조건  
전제조건으로 카프카의 브로커가 최소 3개 이상이어야 한다.   

### 1. 수행 순서
a. 다음의 목록을 각 카프카 서버마다 차례대로 수행해준다. 하나의 서버가 완료되면 그 이후에 다른 서버를 진행해야 한다.   

- 0.10.2.0 버젼 카프카 설치   
- 구버젼 카프카의 설정 파일을 신 버젼 카프카 설정 파일에 복사  
- 0.10.2.0 버젼 카프카의 서버 설정(server.properties)에 다음 설정 추가 (메세지 버젼은 현재 카프카 버젼)  

```
inter.broker.protocol.version=0.10.2   
log.message.format.version=0.9.0.1  
```    

- 기존 카프카 shutdown  
기존 카프카를 shutdown하면 다른 브로커들간에 다시 리더를 정하게 되므로 메세지 유실이 없다.   

```code
  kafka-topics.sh --describe --zookeeper host:port   
```    

를 통해 각 토픽들의 리더를 알 수 있다.  

- 신규 카프카 startup   

b. 0.10.2.0을 지원하는 프로듀서, 컨슈머 적용  

- 메세지 포맷을 계속해서 이전 버젼으로 사용해도 된다. 하지만 이 경우 제로 카피를 사용하지 않아 부하가 걸린다고 한다.

c.  다음의 목록을 각 카프카 서버마다 차례대로 수행한다. 하나의 서버가 완료되면 그 이후에 다른 서버를 진행해야 한다.  

- 카프카 shutdown
- 서버의 설정 파일의 다음 항목 변경   

```  
  log.message.format.version=0.10.2
```  

- 카프카 startup 


### 추가 사항(오프셋 마이그레이션)  
기본적으로 0.9 이전 버젼은 토픽의 오프셋이 주키퍼에 저장되어있다.  
이것이 0.10으로 가면서 카프카에 저장되는 것으로 변경되었다.   

다음을 따라 기존 오프셋을 마이그레이션 할 수 있다.  
- 컨슈머 설정 수정 및 재시작   

```  
  offsets.storage=kafka 
  dual.commit.enabled=true
```    

- 이상 없으면 다시 컨슈머 설정 수정 및 재시작  

```  
  dual.commit.enabled=false
```    



- References
  - https://kafka.apache.org/documentation/#offsetmigration
