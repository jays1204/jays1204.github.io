---
layout: post
title: " add local porject to dependency "
date: 2018-07-10 13:12:59
categories: java jar gradle
---

## Why?  
스프링으로 프로젝트를 진행하다보면 아래와 같이 하는 프로젝트 구성을 하는 경우가 꽤 생겼다.  
- doamin jar  
- API server  
- admin server  
- etc  

spring data jpa로 domain(entity) 선언한 jar만 따로 만들어서 이를 공통으로 사용하였었다.  
이때 발생할수 있는 불편함은 domain jar를 수정하였을때다.  
이 domain을 사용하는 API 서버 프로젝트에서 이를 사용하기 위해선 domain을 따로 컴파일해서 사용하거나 최악으로는 넥서스에 올려서 다시 받아 사용하는거였다.  
몇가지 설정을 추가하면 이런 번잡스러운 추가적인 수동 컴파일없이 프로젝트를 진행할 수 있다.   
 간단한 설정을 추가해서 api server 프로젝트에서 domain jar를 편하기 불러서 사용할 수 있다.  


## 설정 
- 기본 준비  
우선 domain jar 프로젝트와 이를 사용하는 프로젝트가 같은 디렉토리 밑에 있어야 한다. 
 ~/Proejct/domain, ~/Project/api-server  

- 설정  
아래와 같이 domain을 사용할 프로젝트의 setting.gradle과 build.gradle을 설정하면 된다.  

- setting.gradle  

```groovy
rootProject.name = 'api-server'

if (new File('../domain').exists()) {
    include ":domain"
    project(":domain").projectDir = file("../domain")
}
```

- build.gradle  

```groovy
dependecies {
	.........
	 if (new File('../domain').exists()) {
        println "load local domain"
        compile project(":domain")
    } else {
        compile group: 'my.project', name: 'domain', version: DOMAIN_VERSION, changing: true
    }
}
```

주의할것은 실행시 bootRun으로 실행하지 않고 mainClass를 실행하도록 해야한다.

