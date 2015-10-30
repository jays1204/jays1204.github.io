---
layout: post
title:  Node.js Syntax check 'return' error
date:   2015-10-29 23:45:00
categories: Node.js
---

# Node.js 4.2 의 새 기능
node.js가 argon(4.2)으로 버젼을 업데이트 하면서 새로이 생긴 기능 중 하나가 syntax check이다.  
사용법은 간단하다.

```sh
node -c file.js
```

-c 옵션을 주면 해당 파일의 문법을 체크한다. 

예를 들어서 다음의 파일은 아무런 것도 출력하지 않는다.  

```javascript
if (true) {
  console.log('hi');
}
```
```sh
$ node -c test.js
```

하지만 아래 파일은 -c를 이용하여 실행하면 에러를 뱉어낸다.

```javascript
var foo bar;
``` 
```
$ node -c test.js
test.js:1
var foo bar;
^^^

  SyntaxError: Unexpected identifier
  at startup (node.js:108:11)
  at node.js:961:3
```

아래의 파일도 에러를 뱉어낸다.

```javascript
if (true) {
  console.log('work');
  return;
}
```

javascript에서는 return은 함수 내에서만 사용할 수 있으므로 아래와 같은 메세지를 보여주게 된다.

```sh
$ node -c if_return.js
if_return.js:3
return;
^^^^^^

  SyntaxError: Illegal return statement
  at startup (node.js:108:11)
  at node.js:961:3
```

하지만 if_return.js를 실행하게 되면 에러 없이 잘 돌아가게 된다. 

```sh
$ node -c if_return.js
work
```

분명 문법 에러인데 실행되는 게 이상하여 찾아보았다.

검색해본 결과 (http://stackoverflow.com/questions/32490835/node-javascript-files-and-global-namespace) 에 보면 node file.js로 실행시 code는 require에 의해 즉시 실행 함수로 쌓여지게 된다고 한다.  

함수 내에서의 return이므로 에러가 나지 않는 것이 정상이다.

-c 옵션이 코드의 문법만을 체크한다면 맞는 결과이지만 실행시 코드의 문법을 체크하는 것은 아닌걸로 보인다.

-c 옵션 기능의 진행 내역은 https://github.com/nodejs/node/pull/2411 에서 확인할 수 있다.

# 추가
해당 기능을 추가한 이의 의도는 아래 링크에 있다.
https://github.com/nodejs/node-v0.x-archive/issues/9426  

node 로 실행하였을때 실행가능한지의 문법을 체크한다라는 의미로 보인다.   

버그 제보 했고 4.2.2에 반영된다.  
https://github.com/nodejs/node/pull/3587  
