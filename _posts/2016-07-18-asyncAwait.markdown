---
layout: post
title: async & await
date: 2016-07-17 23:36:54
categories: es7 node.js
---

## Async & Await  
es7에 새로이 추가될 예정인 기능들이다. 
이 기능은 기존의 callback hell을 해결하여 좀 더 가독성 높은 코드를 쓰기 위해 만들어졌다.  
물론 ES6 및 기존의 node.js에서도 callback hell을 해결하기 위한 여러가지 노력이 있었다.

## Origianl Callback hell

```javascript
var fs = require('fs');

fs.readFile('./file.txt', function(err, data) {
  if (err) throw err;

  var out = data.toString();

  fs.writeFile('./out.txt', out, function(err, results) {
    if (err) throw err;
    console.log('It\'s saved!');

    fs.readFile('./out.txt', function(e, buf) {
      if (e) throw e;
      
      console.log('data', buf.toString());
    });
  });
});

```

파일을 읽고 쓰고 다시 읽기 위한 코드를 가장 기본적인 callback style로 썼다.  
물론 이런 스타일에 이미 익숙하여 잘 보일 수 있다. 

## Async lib

```javascript
var fs = require('fs');
var async = require('async');

asyc.waterfacll([
  function _read(cb) 
    fs.readFile('./file.txt', cb);
  },
  function _write(data, cb) {
    var out = data.toString();

    fs.writeFile('./out.txt', out, cb);
  },
  function _read2(data, cb) {
    fs.readFile('./out.txt', cb);
}], function(err, buf) {
    if (e) throw e;

    console.log('data', buf.toString());
});

```  
코드를 쓰는 depth가 줄어들어 한결더 읽기가 수월해졌다.  

## Promise(feat. Bluebird)

```javascript
var Promise = require('bluebird');
var fs = Promise.promisifyAll(require('fs'));

fs.readFileAsync('./file.txt')
  .then(function(data) {
    var out = data.toString();

    return fs.writeFileAsync('./out.txt', out);
  })
  .then(function(data) {
    return fs.readFile('./out.txt');
  })
  .then(function(buf) {
    console.log('data', buf.toString());
  })
  .catch(function(err) {
    if (err) throw err;
  });
```
then을 통해 좀더 의미를 명확히 하여 코드 흐름을 쉽게 읽을 수 있다.  
물론 아직까지는 event-driven에 익숙하지 않은 사용자라면 then안에서 그 다음 로직을 호출해야 함이 익숙하지 않거나 왜 해야 하는지 어려울 수 있다.  
이런 문제와 가독성을 높이기 위해 나오는 것이 async & await 이다. 

## Async & Await

ee까지 해당 기능은 ES7에 제안중이여서 (물론 확정되리라 생각되지만) 해당 기능을 사용하기 위한 가장 간편한 방법은 library를 통한 체험이다.  
물론 babel을 이용할 수도 있다! 이 글에서는 asycawait 라이브러리를 통해 소개한다.

```javascript
var async = require('asyncawait/async');
var await = require('asyncawait/await');
var Promise = require('bluebird');
var fs = Promise.promisifyAll(require('fs'));

var readAndWriteTasks = async(function def() {
  var data = await(fs.readFileAsync('./file.txt'));
  var out = data.toString();
  var writeResult = await( fs.writeFileAsync('./out.txt', out) );
  var data2 = await( fs.readFileAsync('./out.txt') );
  
  return data2;
});

readAndWriteTasks()
  .then(function(data) {
    console.log('data', data.toString());
  })
  .catch(function(err) {
    if (err) throw err;
  });

```  

async, await는 promsie객체를 기본으로 한다.  
await는 promise가 settled(모두 수행)될때 까지 기다린다.   
물론 이 과정(async와 await를 거치는 과정)은 기존 node.js의 non-blocking 과정을 해치지 않는다고 한다.  

- async   
  - 정의한 함수(여기서는 def() )가 return value를 줄때까지 기다리게 된다.  
  - 정의한 함수는 return값을 resolve에 담아 promise 객체를 return한다.  
  - 따라서 단독으로 사용 될 수 있다.  


- await  
  - await를 쓰기 위해서는 항상 async로 감싸주어야 함이 필수이다.  
  - await에서 error가 발생할시 처리를 위해 async내부에 try/catch 또는 async 호출후 then, catch를 처리해주어야 한다.  

async & await를 쓰면서 기존보다 좀더 동기(?)적으로 로직을 쓸 수 있게 되어 가독성 및 event-driven 초심자에게도 더 접근이 쉬운 코드가 되었다고 생각한다.  

## References  
- https://tc39.github.io/ecmascript-asyncawait/
- https://jakearchibald.com/2014/es7-async-functions/
- https://github.com/yortus/asyncawait
