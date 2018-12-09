---
layout: post
title: "Deployment for feature"
date: 2018-12-09 15:32:17
categories: aws beantaslk feature devops deployment ci
---  

# 개발 기능 테스트   
일반적으로 기능 A를 개발하고 이를 production에 배포하기 이전의 단계는 보통 아래와 같다.   

  1. 개발자가 신규 기능 코드를 A브랜치로 push  
  2. 개발용 서버(beantalk enviroment)에 A 브랜치로 배포   
  3. QA, 기능 기획자가 이에 대한 테스트   
  4. 테스트에 대한 수정 처리  

이렇게 개발한 것에 대한 검수를 마치고 배포하여 사전에 장애나 잘못된 기능 배포를 방지하려 한다.  
문제는 보통 개발 서버는 1 ~ 2개인거(dev1, dev2)에 반해 feature를 배포해서 테스트 하고자 하는 것은 동시에 n회 발생할 수 있게 되는 점이다.  
보통 이럴땐 개발자 A가 다른 개발자들에게 현재 내가 dev1을 쓰고 있으니 dev1에 배포하지 말아달라고 구두로 이야기 하는 경우가 많다.  
짧은 시간동안 쓸거면 괜찮지만 이게 아닐 경우에는 다른 개발자의 테스트가 밀리는 문제가 발생할 수 있다.   
또는 기획자 A1, 개발자 B1이 테스트하기 위해 1을 배포해둔 dev1에 기획자 A2가 이를 인지못하고 기능 2에 대한 테스트를 진행하는 헛수고가 발생하기도 한다.  

이 글은 이런 문제를 해결하기 위해 도입한 배포기능 라이브러에 대한 컨셉 및 기능 소개이다.   

# Dynamic server deploy  
feature A, B, C, ... Z를 위한 전용 서버를 관리해주는 기능이 핵심이다.  
각기 다른 feature에 대해 전용 vm 또는 컨테이너에 배포를 하고 해당 feature의 전용 url을 갖게 한다.  
이를 위해 feature마다 전용 infra를 제공하기 위해 AWS에서 제공하는 beanstalk를 사용하였다.  
beantalk가 아니더라도 사내에서 동적으로 vm을 할당해주는 기능이 있다면 이를 사용하면 된다.   

기본적인 흐름은 다음과 같다.  
  1. 주어진 이름에 따라(보통은 feature 이름) 신규 beantalks 환경(이하 신규 서버)을 만든다.   
  2. 신규 서버가 사용 가능해지면 이 서버에 war, zip 등을 배포한다.  
  3. 배포가 완료되면 배포된 서버의 주소를 개발자에게 알려준다.  
  4. 배포된지 일정 시간이 지나면 자동으로 생성했던 신규 서버 infra를 제거한다.  

위의 기능을 수행할 로직을 닮은 library를 만들어 이를 Jenkins에서 실행하여 관리하도록 하였다.  

## feature deploy   
이곳의 설명은 다음의 구성을 전제로 이루어졌다.  
  - web application server  
  - Dockerized  
  - AWS beanstalk multi container 배포  
  - ECR for Docker image 
  - Jenkins For CI/CD  

feature 배포를 위해 도커 이미지를 만들고 이를 새로운 beanstalk env에 배포한다.  

1. build  
도커 이미지를 만드는 과정은 큰 특징은 없다.  
각자의 application에 맞는 build 과정을 수행하고 이에 따른 Docker image를 만들어 낸다.   
다만 도커 이미지 빌드를 할때의 코드는 cli command보다 docker remote api를 사용하여 가독성 있는 코드로 관리할 수 있게 하였다.  
만들어진 docker image는 ECR에 푸시한다.   
- ECR에는 특정 이름에 대해 하루가 지나면 이미지를 삭제하는 설정을 추가하여 불필요한 이미지를 유지하지 않도록 하였다.  

2. deploy  
배포를 위해 해당 feature를 위한 전용 beanstalks env가 필요하다.  
우선 전용 env가 있는지 체크한다.  
이는 리소스 낭비를 막기 위해 같은 feature에 대해 새로이 env를 만들지 않게 하는 것이다.   
체크 후 없다면 생성하도록 요청한다.  
생성 요청시에는 다음 작업이 필요하다.   

  - feature명에 기반한 신규 beanstalk env 이름 설정
  - lifecycle 관리를 위한 상태 tag 및  생성일 기록 tag 
    - 생얼일 TAG를 기준으로 특정 기간이 지나면 사용하지 않는 env를 자동으로 삭제하기 위함이다.  
  - 미리 만들어둔 beanstalk env configuration을 사용하도록 지정
    - 이는 기존 env의 설정을 복사하여 사용할 instnace type 정도만 바꿔주면 된다.

이제 사용할 env에 대해 status를 체크하여 사용가능해지는 시점까지 기다린다.   
이후 사용가능해지는 signal을 받게되면 1에서 만든 배포 파일을 배포하도록 한다.  

이를 위해서는 아래 내용을 포함하는 Dockerrun 템플릿이 필요하다.   

  - Dockerrun 템플릿에 feature 배포에 맞는 변수를 넣어준다.   
    - Dockeerrun.template.json을 읽어와 이 곳에 필요한 infra 설정 값을 채워주었다.  
  - 1에서 빌드한 이미지의 이름을 넣어주고 배포를 위한 zip file을 만든다.   

배포가 완료되었다는 signal을 받으면 이를 slack을 통해 사용가능함을 알려준다.  

3. clean  
개발자가 배포를 위해 새로 생성한 beantalk를 정리하는 기능이다.   
주기적으로 처리하는 작업으로 생성일 기준 n일이 지나면 자동으로 beanstalk env를 삭제하게 해두었다.  

# Code For Infra  
이 배포 전략의 로직 및 사용 방법은 간단하다.  
배포시마다 신규 beanstalk 환경을 만들고 그곳에 배포하고 시간이 경과하면 해당 환경을 삭제하기만 하면 된다.  
개발자들에게 달라지는 점은 하나도 없다.  
다만 이런 기능을 적용하기 위해선 기존에 code로 infra관리 및 build가 되어야 한다.  
이미 도커를 쓰고 있다면 이런 기능을 적용하기 매우 편리해진다.  
컨테이너를 할당받고 해당 컨테이너에 배포하고 새로운 접속 주소만 설정만 바꿔주면 되기때문이다.  
vm 서버를 쓰고 있다면 ansible이 훌륭한 대안이 될 수 있다.  
Dockerfile의 infra 설정 부붙을 ansible의 playbook으로 대체하여 사용할 수 있다.



## References  
- https://docs.docker.com/engine/api/v1.24/  
- https://aws.amazon.com/ko/elasticbeanstalk/  
