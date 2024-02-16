---
layout: post
title: " Node.js Http Agent "
date: 2024-02-16 20:47:56
categories: nodejs http keepalive
---

# http 연결
개발하다보면 http 요청을 많이 쓰게 되는 편이고, 보통은 keep-alive를 위해 httpAgent를 설정하는 편이다.
보통은 아래와 같이 설정해서 keepAlive를 설정하여 커넥션 맺는 비용을 아끼려한다.

```javascript
const http = require('node:http');
const keepAliveAgent = new http.Agent({ keepAlive: true });
options.agent = keepAliveAgent;
http.request(options, onResponseCallback);
```

보통은 이렇게 해도 별 이슈는 없다.  
하지만 요청이 매우 빈번하 경우(빈번의 정의를 수치로 내리긴 어렵다...)에는 connection 관련해서 에러가 발생할 수 있다. 
keepAliveAgent 를 사용하는 client 입장에서는 connection이 살아있다고 생각해서 connection을 agent에서 들고와 요청을 시도한다. 
하지만 모종의 이유(서버측의 LB timeout 설정 등)로 인해 서버에서는 이미 해당 connection을 유효하지 않은 것으로 취급할 수 있다. 
이럴 경우 client에서는 이를 인지하지 못한채 유효하지 않은 connection을 보내게 된다.  
이는 아래와 같이 Agent 옵션에 하나만 추가하면 해결할 수도 있다.
```javascript
const keepAliveAgent = new http.Agent({ keepAlive: true, scheduling: 'fifo' });
```
fifo 설정이 추가되었다. 기본은 lifo이다. lifo는 가장 최근에 사용한 소켓을 사용, fifo는 가장 오래전에 쓴 소켓을 사용한다. 
lifo의 경우 쓰던것만 계속 쓰는 경우가 발생할 수 있어 특정 소켓은 사용안한채로 계속 방치될수 있고 이로 인해 커넥션이 유효하지 않게 될 수 있다. 
그래서 요청이 꽤나 빈번한 경우에는 fifo로 설정해서 커넥션(소켓)이 좀 더 고르게 사용되게 설정하여 에러를 방지할 수 있다.


# 참조
- https://nodejs.org/api/http.html#new-agentoptions
- https://reaperes.medium.com/aws-alb-%EC%9D%98-idle-timeout-%EC%97%90-%EA%B4%80%ED%95%98%EC%97%AC-7addb8bfb886
