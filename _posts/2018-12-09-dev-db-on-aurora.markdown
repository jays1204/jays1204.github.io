---
layout: post
title: "Database for dev, 개발용 DB 구축하기"
date: 2018-12-09 14:51:59
categories: database dev aws aurora devops
---

# 개발 한경 구축    
개발을 진행하다 보면 100의 99는 라이브환경과 개발 환경을 구분지어 개발을 하게 된다.  
같은 코드에 dev용 설정, production(이하 prod)용 설정을 환경에 맞게 주입하여 설정 값을 사용한다.  
이때 일반적으로 사용되는 설정값은 보통 db주소, server host 등이 있다.  
이 글에서는 AWS의 기능을 이용하여 개발 환경에서 사용할 DB를 손쉽게 구축하는 것을 다룬다.  


# AWS Aurora clone  
이 내용의 대부분의 아이디어는 [aurora-echo][https://github.com/blacklocus/aurora-echo] 프로젝트에서 가져왔다.
위 라이브러이에서도 아래 서술할 단계등을 제공하여 개발용 DB 구축을 쉽게 도와준다. 
하지만 한가지 필요한 기능이 없는 것이 있어 새로이 라이브러리르 만들었다.  

AWS에서 제공하는 RDS 서비스중 하나인 Aurora에서는 현재 사용중인 cluster를 빠르게 복제하는 기능을 제공한다.  
이 기능을 이용하여 간편하게 개발 환경용 DB를 구축할 수 있다.  
AWS예제에서 제공하는 것처럼 다음의 커맨드만 실행하면 일정시간의 복제 시간 후에 사용 가능한 DB가 만들어진다.  

```sh
aws rds restore-db-cluster-to-point-in-time \
    --source-db-cluster-identifier sample-source-cluster \
    --db-cluster-identifier sample-cluster-clone \
    --restore-type copy-on-write \
    --use-latest-restorable-time
```
원하는 대로 DB가 생성되었으니 이제 이를 개발 DB로 사용할 수 있다. 
이렇게 클론하여 생성한 cluster는 source cluster와 같은 내용과 형태를 갖는다. 

# n-times clone   
한번 생성한 개발 DB를 별다른 변경없이 계속 사용한다면 위의 커맨드 만으로도 충분하다.  
하지만 개발단계에서 넣어주기 힘든 production 용 데이터가 매일 매일 계속 많은 양이 생성되고 있고  
이를 개발 단계에서도 이용하고 싶을 때가 생긴다.  
대표적인 예는 기능 검수를 위한 개발 단계에서의 QA다.  
좀 더 정확한 QA를 위해 가급적이면 항상 최신의 데이터를 사용하고자 하는 요구조건이 발생하기도 한다.  
이를 위해 매일 하루에 한번씩 cluster에 대해 clone을 하여 개발 환경용 DB를 구축하기로 했다.  

# Lifecycle & Clone  
매일 clone을 하고자 했을때 이전에 생성한 clone cluster의 관리와 새로운 cluster 로의 변경, 그리고 일정한 접속 주소가 필요하였다.  
일정한 접속주소의 경우 매일 clone시마다 DB 접속 주소를 새로이 clone의 주소로 바꿀 수 없기에 필요하였다.  
이를 위해 ROUTE53에 미리 등록해둔 개발용 DB주소에 새로이 clone된 cluster를 연결하였다.  
그리고 신규 clone cluster로 교체하기 위해서, 혹시나 모를 같은 cluster를 중복해서 clone하지 않기 위해 clutser에 대한 lifecycle 관리가 필요해졌다.  
구성한 lifecycle은 총 단계로 아래와 같다. 

  - created: clone 생성요청을 한 생태이다.  
  - ready : clone 이 생성완료되어 접속하여 사용가능해진 상태이다. 
  - connected : clone 상태의 cluster가 ROUTE53에 연결된 상태다. 
  - aborted: route53에 연결되었었다가 다시 연결이 해제된 cluster의 상태이다. 


# Clone Step  
위의 life cycle를 이용하여 다음의 단계로 매일 개발 DB를 생성한다.  

1. Clone  
  - 주어진 source에 해당하는 DB cluster에 대해 clone을 생성한다. 이때 created tag로 생성하도록 요청한다. 
    -  working daily 기준으로 생성할거나 보통은 -YYYYMMDD 의 postfix를 이름에 넣어주었다.  
  - 이 cluster에 대한 생성이 완료되면 created tag는 삭제하고 ready tag를 붙여준다. 
  - 이때 RDS가 사용가능한지를 check하는 기능이 필요하다. aurora-echo 에서는 해당 기능을 제공하지 않아 새로이 만들었다.  

2. Connect  
  - 주어진 source cluster에 대해 ready 상태인지 판별 후 주어진 domain에 연결하는 작업을 한다. 
  - ROUTE53 연결이 완료되면  connected라는 tag를 cluster에 붙여준다.  
  - 이전에 같은 도에인에 연결된 cluster가 잇었다면 해당 cluster에는 aborted 라는 tag를 붙여준다.  
3. Clean  
  - aborted tag가 붙은 cluster 목록을 가져와 모두 삭제한다.  


## 필요한 AWS permissions  
위의 clone을 진행하기 위해선 다음과 같은 AWS cli를 실행할 권한이 필요하다.   

- restore-db-cluster-to-point-in-time
- describe-db-clusters
- create-db-instance
- delete-db-cluster
- delete-db-instance
- describe-db-instances
- change-resource-record-sets  
- etc

## 마무리  
python에 익숙하고 어느정도 AWS에 대해 다룰줄 안다면 [aurora-echo][https://github.com/blacklocus/aurora-echo] 를 사용하면 빠르게 구축할 수 있다.   
해당 라이브러리에서는 이미 life cycle 관리를 위한 태깅을 해주고 있으므로 개발 DB를 구축하는데 용이하다.  
다만 만들어진 cluster에 대한 상태 체크 및 도메인 연결등은 따로 구축 해야한다. 

# References  
- https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.Managing.Clone.html  
- https://lenditkr.github.io/infrastructure/test-server/  
