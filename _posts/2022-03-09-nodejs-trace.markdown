---
layout: post
title: " node.js context 추적하기 "
date: 2022-03-09 03:00:36
categories: node.js, als, AsyncLocalStorage
---

## Tracing context
API 서버를 개발하게되면 서비스 기능과는 연관이 없지만 추가해야하는 기능이 있다. 
바로 context 추적을 위한 request마다의 id 부여이다.  이는 http api 서버 뿐 아니라 단위 작업을 처리하는 애플리케이션이라면 어떤 곳에서든 필요하다.  
보통은 http request가 처음 인입된 시점에 request에 임의의 id를 부여하고 해당 request에 의해 발행되는 log마다 이 id를 같이 기록하게 한다.  
이를 통해 장애 발생시 로그를 볼때 해당 request의 log만을 쉽게 찾아 볼 수 있다.  
문제는 node.js는 그동안 이 작업이 매우 불편했다는 것이다.  

## Tracing Context With Node.js
많이들 사용하는 express.js 로 예를 들어보자.  
보통은 다음과 같이 가장 먼저 실행되는 미들웨어에서 req.id에 유니크한 값을 부여한다.

```javascript
app.use((req, res, next) => {
  req.id = uuid();
  return next();
});
```  
request마다 id를 부여하는 것은 꽤나 쉽다.  
문제는 이 id를 꺼내는 방식이다. 이 id를 꺼내기 위해서는 controller에서 가져온 request 또는 이 id를 service, dao method 호출할때 마다 계속 넘겨주어야 했었다.  

```javascript
const reqId = req.id);
userService.register(newUserData, reqId);
.... 
userDao.addUser(userDaoData, reqId);
```   

이렇게 되면 문제는 거의 모든 method마다 reqId를 arguments로 설정해두어야 하고 또 이 값을 매번 넘겨주는 코드도 작성해주어야 한다.  
이렇게 되면 기능과 상관없는 운영을 위한 코드가 추가되어 관리측면에서 좋지 않다.  


## AsyncLocalStorage
AsyncLocalStorage(이하 als)를 통해 context 추적을 위한 request id를 쉽게 저장하고 꺼내쓸 수 있다.  

사용 방법은 간단하다. 
1. 사용할 Storage를 만든다. 이때 Storage는 아무거나 상관없다. json, map, array, string, number 등 모두 가능하다. 보통은 {}(objec)t를 사용한다.  
2. 1의 sotrage를 als에 설정해준다.  
3. storage에 저장된 데이터를 꺼내 사용한다. 

이를 간단하게 코드로 작성하면 다음과 같다.   

```javascript
// als.js  app에서 공통으로 사용할 als
const { AsyncLocalStorage } = require('async_hooks');
const asyncLocalStorage = new AsyncLocalStorage();


module.exports = {
  als: asyncLocalStorage
};

// app.js express main app
const { als } = require(./als');

...
// 가장 먼저 실행되는 middleware에 선언하길 권장
// job, consuemr 등이라면 job이 시작되는 시점 또는 consume할때마다 id를 설정하게 한다. 
const myStore = { };
app.use((req, res, next) => {
  return als.run(myStore, () => {
      const store = als.getStore();
      sotre.id = uuid();
      return next();
  });
});

// userService.js
const { als } = require(./als');
...
function register(userData) {
  ...
  const store = als.getStore();
  console.log('traceId', store.id); // request에 따라 각기 다른 id
  ...
}

```

asyncLocalStorage 에는 store를 설정하는 method가 2가지가 있다. 각자 장단이 있으니 상황에 따라 사용하면 된다. 

1. run(store, callback)
store를 설정한다. 다만 이 store는 callback 내 context에서만 유효하다. callback 바깥으로 빠져나오면 store는 유효하지 않게 된다.

2. enterWith(store)
설정한 store를 어디서나 꺼내 쓸 수 있다.


https://github.com/nodejs/node/issues/41285 링크를 보면 알 수 있듯이 run을 쓰는 경우 비동기 method가 호출되어야 store가 설정되는데 비동기 method 호출없이 store에 접근하여 store내 값 설정이 의도대로 되지 않는 상황이 발생할 수 있다.  




# References
  - https://nodejs.org/api/async_context.html#asynclocalstorageenterwithstore
