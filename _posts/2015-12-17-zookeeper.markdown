---
layout: post
title: " Zookeeper overview"
date: 2015-12-17 18:24:56
categories: zookeeper
---

## **Zookeeper Overview**
zookeeper는 znode라고 불리는 node의 tree구조로 데이터 구조를 유지한다.  
각 znode는 데이터와 ACL을 담을 수 있다. 

zookeeper에 의해 제공되는 namespace는 일반 파일시스템과 매우 유사하다.   
Zookeeper와 일반 파일 시스템의 주요한 차이점은 모든 znode는 znode와 관련된 data를 갖고 이 data의 양은 제한이 있다는 것이다.  
경로는 slash("/")로 구분된다. zookeeper의 모든 znode는 이 path에 의해 구분된다.  
root("/")를 제외하면 모든 znode는 parent를 갖는다. 예를 들면 "/mina/pretty"의 parent는 "/mina"이다.
Zoookeper는 협업을 위한 data를 저장하기 위해 설계 되었다. 이 data는 상태 정보, 설정 값, 위치 정보 등을 의미한다.  
zookeeper에 저장되는 데이터의 최대 크기는 1M이다. 또한 데이터는 memory에 저장된다. 
  - memory에 저장하지만 복구를 위해 zoo.cfg에 설정된 dataDir에 복구를 위한 디렉토리를 설정할 수 있다.  
  - 해당 directory에 생기는 snapshot파일을 이용해 zookeeper가 다시 올라오면서 데이터가 복구된다.  
  - data는 byte배열로 저장된다.  

또한 주키퍼 서비스 구성을 할때 각 주키퍼 서버들은 서로에 대해 알고 있어야하며 client역시 모든 주키퍼 서버 목록을 알고 있어야 한다.  

client들은 하나의 주키퍼 서버에만 접속을 한다. client는 TCP커넥션을 계속해서 유지하게 된다. 연결이 깨지게 되면 client는
다른 주키퍼 서버에 연결할 것이다. 

## **ZNode**  
znode에는 수명에 관해 두 가지 mode이 있다. 둘중 하나의 mode만 가능하다.    

  1. ephemeral mode(임시)  
    - 해당 znode를 생성하도록 요청한 client의 connection이 종료되면 자동으로 삭제되는 znode이다.   
    - child znode를 가질 수 없다. 
  2. persistent mode(영구)
    - 삭제 요청을 하기 전까지 보존되는 znode이다.  

uniquness를 보장하는 모드도 설정 가능하다.  

  - sequence mode  
    - 이 모드를 설정하게 되면 같은 이름의 znode를 생성할 수 있다.  다만 postfix로 1~10까지 숫자가 붙어서 구분이 될 수 있다.  
    - /tasks로 sequence znode를 생성하면 /tasks-1, /tasks-2와 같이 생성된다.  

## **ACL**  
Access Control List이다.
Znode의 접근 권한을 설정하는 것으로 자식 node에게 상속되지 않는다.  
ACL에는 Permission과 Scheme가 있다.  
Permission은 말 그대로 할 수 있는 행위의 목록이고 Scheme는 Permission을 어떤 client가 할 수 있는지 규정한다.  


## **API**  
  1. create /path data
    - /path 로 znode를 만들면서 znode는 data를 갖는다.  
    - -e를 사용하면 임시 znode를 만들 수 있다. 
    - -s를 사용하면 sequence znode를 만들 수 있다.  
  2. delete /path  
    - /path znode를 삭제한다.
  3. exists /path
    - /path znode가 있는지 확인한다. 
  4. setData /path data
    - /path znode의 데이터를 data로 저장한다.
  5. getData /path
    - /path znode의 데이터를 가져온다. 
  6. getChildren /path
    - /path znode의 자식 목록을 가져온다. 
  7. stat /path true  
    - 이미 있는 znode의 속성을 가져오고 true를 주면 watch를 설정할 수 있다.  
  7. 기타
    - ls / : root밑의 znode목록을 가져온다. 
      

## **Watch**  
알림이 한번 발생하는 1회성 작업이다.  반복적으로 받고자 한다면 한 번 알림을 받은 후 다시 또 알림을 설정해야 한다.  

다만 알림을 추가로 등록할때 등록을 준비 하는 사이에 발생할 수 있는 데이터 등록과 같은 작업에 대해 조심성 있게 해야 한다.  

물론 주키퍼는 알림 전파의 순서는 보장한다.  

## **Version**  
Znode는 버젼을 갖는다. 아래는 그 예제이다.  

```bash
[zk: localhost:2182(CONNECTED) 2] get /info
mmm
....
dataVersion = 2

```

dataVersion이 2이다. 이전에 set을 통해 data를 두차례 변경해주었기 때문이다.   
최초의 dataVersion은 0이며 수정시마다 1씩 증가한다.  

## **Standalone vs Quorum**  
주키퍼 서버를 하나만 띄울 때는 standalone, quorum은 앙상블이라고 불르는 주키퍼 서버들 그룹으로 서로 상태가 복제되고 client의 요청을 나누어 처리한다. 

## **주키퍼 앙상블**   
주키퍼를 앙상블로 실행하기 위해서는 다음과 같은 설정을 하면 된다.  

```bash
zoo.cfg
...
dataDir=./data
clientPort=2181
server.1=127.0.0.1:2222:2223
server.2=127.0.0.1:3333:3334
server.3=127.0.0.1:4444:4445
```

3개의 주키퍼 서버를 사용해서 앙상블을 구성한다.  
server.n은 각 서버 n이 사용하는 주소와 포트 번호를 적는다.  
값의 형태는 아래의 형식을 따른다.  
server.n=IP_ADDRESS:TCP_PORT_FOR_QUORUM:TCP_PORT_FOR_ELECT_LEADER

설정이후 각 서버의 dataDir에 myid라는 파일을 만들고 각각 server.n의 n을 저장해주면 된다.  

이제 각 서버를 띄우고 과반수 이상뜨면 주키퍼 서비스가 구성이되며 리더를 선출한다.  
아래는 1번이 리더로 선출되었다.  

```bash
2015-12-17 23:05:33,933 [myid:1] - INFO  [QuorumPeer[myid=1]/0:0:0:0:0:0:0:0:2181:Follower@63] - FOLLOWING - LEADER
ELECTION TOOK - 50858
```

접속을 할때는 다음 커맨드를 이용할 수 있다.  

```bash
$ ./bin/zkCli.sh -server 127.0.0.1:2181,127.0.1:2182,127.0.0.1:2183
``` 

이때 주의할 것은 comma(,) 다음에 빈칸이 허용되지 않는 것이다.  

## **Zookeeper dashboard**  
git@github.com:phunt/zookeeper_dashboard.git


- References
  - https://cwiki.apache.org/confluence/display/ZOOKEEPER/index
  - http://blog.seulgi.kim/2014/05/zookeeper-1-znode-zookeeper-data.html
  - http://www.xenomity.com/entry/Apache-ZooKeeper-1-Overview
