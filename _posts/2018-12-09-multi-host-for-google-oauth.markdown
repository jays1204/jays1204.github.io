---
layout: post
title: " multi host for google oauth login  "
date: 2018-12-09 16:30:22
categories: google oauth multi domain host 
---

# 구글 OAUTH login  
많은 회사에서 구글 비지니스 계정을 발급하여 이를 사내 계정으로 사용하고 있다.  
해당 구글 계정을 통해 사내 대시보드에 로그인 하는 기능을 제공하기도 한다.  
구글 로그인을 한번 해두면 사내 대시보드에 따로 계정을 만들어 관리하지 않아도 편하게 로그인하여 기능을 사용 할 수 있다.  
문제는 구글 로그인을 통해 대시보드에 로그인을 해야 하는데 이 대시보드의 주소가 동적으로 바뀌는 경우이다.  

## dynamic url dashboard  
테스트를 위해 배포한 대시보드가 각 배포마다 접속 주소(host, url)이 달라질 수 있다.  
이외에도 서버를 옮긴다든지, 임시로 띄운 대시보드라든지 해서 주소가 바뀔 수 있다.  
이럴 경우에는 google oauth dashboard에서 허용 가능한 uri에 해당 주소를 등록해 주어야 한다.  
위와 같은 일이 빈번하지 않다면 수동으로 uri를 때마다 등록해주면 된다.   
문제는 빈번하게 발생하는 케이스다.  
이전 글에서 다룬 feature 배포 처럼 매 feature 배포본마다 주소가 host 주소가 바뀔 경우에는 매번 등록해준다는 것은 
여간 리소스 낭비가 아니다.  

이런 리소스 낭비를 막고자 동적으로 변하는 host에서도 구글 oauth 로그인을 할 수 잇는 서버를 만드는 것을 소개한다.  

## nginx for dev google oauth  
이를 위해 필요한 것은 개발용으로 사용할 대표 google oauth 주소와 이 주소와 연결되는 서버이다.  
서버는 nginx를 사용했으나 굳이 nginx를 사용하지 않고 proxy 처리가 가능한 다른 서버를 이용해도 된다.   

### 1. nginx 설정 
dev-test-jays1204.github.io 라는 주소를 가진 서버에 nginx를 설치하였다.  
이 nginx는 아래의 설정을 포함한다.  

```
location /custom-oauth/cb {
  return 302 http://$arg_state?$request_uri;
}
```
위의 설정된 주소로 올 경우 arg_state의 주소로 요청 uri 그대로 다시 돌려주는 기능이다.  


### 2. application 설정  
이제 구글 oauth를 사용하는 application의 oauth 설정을 건드리면 된다.  
로그인시 사용할 callback url만 변경하면 된다.
기존에는 application.com/google/oauth 라는 것을 사용했다면 이제는 다음의 값을 넣는다.  
  - nginx에서_설정한_locatoin_주소?state=배포된_대시보드_서버_oauth_cb_url

아래는 passport.js라는 node.js 라이브러리로 예제를 만들었다.  

```javascript 
// 기존
passport.use(new GoogleStrategy({
    consumerKey: GOOGLE_CONSUMER_KEY,
    consumerSecret: GOOGLE_CONSUMER_SECRET,
    callbackURL: "https://www.example.com/auth/google/callback"
  },
...

// 변경
passport.use(new GoogleStrategy({
    consumerKey: GOOGLE_CONSUMER_KEY,
    consumerSecret: GOOGLE_CONSUMER_SECRET,
    callbackURL: "https://dev-test-jays1204.github.io/custom-oauth/cb?state={this_server_host}"
  },
```  

이 설정을 통해 google oauth 진행시 callback 과정이 아래와 같이 진행된다.  

- google oauth 요청  
- 중간 생략...   
- google 에서 nginx 에 설정된 location callback 주소로 302 redirect   
- nginx 서버에서 이를 받아 그대로 state로 설정된 주소로 302 redirect  
- 대시보드에서 로그인 처리 성공  


### 3. 개발용 oauth host를 google에 등록   
마지막 과정이다.
위 1에서 설정한 nginx의 host주소를 google oauth 대시보드 설정에서 허용가능한 uri로 등록한다.  

## References  
- https://www.kcoleman.me/2016/12/28/wildcard-google-auth-for-multiple-subdomains.html  

