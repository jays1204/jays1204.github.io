---
layout: post
title: "node.js process.nextTick vs setImmediate"
date: 2016-11-27 23:15:10
categories: node.js
---

# nextTick vs setImmediate

사실 잘 사용하지는 않지만 node.js 이야기가 나올때마다 자주 나오는 이야기중 하나라 정리한다.  

nextTick, setImmediate 둘 다 함수로서 함수 안의 내용을 실행시키고자 할 때 사용한다.  

node는 처리해야 할 이벤트들을 순서대로 쌓아 두는 내부 큐(event loop)가 있다.
이 내부 큐를 어떻게 쓰느냐가 둘의 차이이다.  
nextTick은 이 큐의 가장 앞단에 할일을 넣어준다.  (I/O작업과 다른 콜백들에 우선한다. 그렇지만 현재 실행중인 것보다 우선하지는 않는다.)  
nextTick이 호출된 순대로 큐의 head부터 tail방향으로 쌓이게 된다.  
반대로 setImmediate는 실행할 내용을 이 큐의 마지막에 넣어준다.(I/O작업과 다른 콜백들 뒤다.)

아래 스택 오버플로우에서 가져온 예제를 보면 명확히 알 수 있다.

```javascript  
function log(n) { console.log(n); }

process.nextTick(function A() {
    process.nextTick(function B() {
        log(1);
        process.nextTick(function D() { log(2); });
        process.nextTick(function E() { log(3); });
    });
    process.nextTick(function C() {
        log(4);
        process.nextTick(function F() { log(5); });
        process.nextTick(function G() { log(6); });
    });
});

setTimeout(function timeout() {
    console.log('TIMEOUT FIRED');
}, 0)

```

출력은 다음과 같다.   
1, 4, 2, 3, 5, 6, TIMEOUT FIRED   
*@Isitea 님께서 댓글로 잘못 작성된 부분을 알려주시어 늦게나마 내용을 수정합니다.*  
nextTick의 경우 event loop로 들어가기 이전에 코드가 바로 실행되기 때문에 위와 같은 출력이 발생합니다.

'TIMEOUT FIRED'은 setTimeout이므로 큐에 넣어서 차례를 기다리므로 마지막에 실행된다.  

아래는 setImmediate이다.   

```javascript  
function log(n) { console.log(n); }

setImmediate(function B() {
    log(1);
    setImmediate(function D() { log(2); });
    setImmediate(function E() { log(3); });
    });
setImmediate(function C() {
    log(4);
    setImmediate(function F() { log(5); });
    setImmediate(function G() { log(6); });
    });

setTimeout(function timeout() {
    console.log('TIMEOUT FIRED');
    }, 0)

```

출력은 다음과 같다.  
1 , 4, TIMEOUT FIRED, 2, 3, 5, 6  

setImmediate B, C가 쌓이고 그리고 setTimeout이 쌓이고 다른 D, E, F, G가 순서대로 쌓여서 실행된다.  

setTimeout 과 setImmediate도 차이가 있다. setTimeout(fn, 0)이어도 아주 미세한 ms딜레이가 있어서 setImmediate보다 나중에 실행될 수도 있다.

## References
 - http://stackoverflow.com/questions/17502948/nexttick-vs-setimmediate-visual-explanation
 - http://becausejavascript.com/node-js-process-nexttick-vs-setimmediate/
