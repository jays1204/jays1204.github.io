---
layout: post
title:  Node.js With ES6
date:   2015-10-13 21:00:00
categories: node.js
---

# Node.js 4.x에서 정식 기능으로 채택된 ES6기능들
이전과 달리 --harmony를 argument로 주지 않더라고 기본적으로 제공하는 ES6기능들이 생기었다.   
상세한 내용은 https://nodejs.org/en/docs/es6 를 참고하면 된다.  
여기서는 간단한, 흥미로운 몇가지에 대해서만 간단히 정리한다.

## 1.let
let은 지역변수를 선언할수 있게 해준다.
GLOBAL선언시에는 var와 같다. 하지만 function, {}내에서 선언되면 해당 scope안에서만 값이 유지되며 이후에는 정리된다.  

```
for(let i =0; i<10;i++) {
  consoe.log('i %d', i);
}
```
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let

## 2.const
read-only 값을 만든다. immutable을 의미하는 것은 아니다.  
const로 선언한 값은 nodejs 4.0에서는 변경 불가및 같은 이름의 var 선언 불가.  

```
const NAME='JAYS';
console.log('NAME', NAME);

const NAME='HI'; //error!
```


## 3. Class
자바스크립트 클래스는 ES6에소 소개되었고 기존 자바스크립트의 프로토 타입 기반의 상속을 넘어서는 syntatic sugar이다.  
class문법은 새로운 객체지향 상속 모델을 자바스크립트에 소개하는것이 아니다. 자바스크립트 클래스는 객체를 만들고 상속을 다루기 위한 더 간단하고 명백한 문법을 제공한다.  

클래스의 정의  
클래스는 사실 함수 표현식, 함수 선언과 같이 정의할수 있으며 클래스 문법은 두가지 요소를 갖고 있다: 클래스 표현, 클래스 선언  

클래스 선언

클래스를 정의하는 한가지 방법은 클래스 선언을 이용하는 것이다  
클래스를 선언하기 위해서 클래스(class)키워드와 함께 해당 클래스의 이름을 쓰면 된다.   
ex)

```
class Polygfon {
  constructor(height, width) {
    this.height = heigth;
    this.width = width;
  }
}
```
 호이스팅

 함수 선언과 클래스 선언에 있어서 가장 중요한 차이점은 함수 선언은 호이스팅이 되지만 클래스 선언은 그렇지 않은 것이다.  
여러분은 첫번째로 클래스를 선언해야하고 그리고나서 접근해야 한다.  
아래와 같은 코드는 ReferenceError를 발생시킬 것이다.  

```
var p = new Polygon();
calss Polygon() {

};
```

클래스 표현식

클래스 표현식은 클래스를 정의하는 다른 방법이다. 클래스 표현식은 이름을 붙을 수도 아닐 수도 있다. 이름이 있는 클래스 표현식의 주어진 이름은 클래스의 바디에 로컬에 저장된다.


클래스 바디 그리고 method 정의  
클래스의 바디는 괄호{}안의 부분을 말한다. 이것은 클래스 멤버, method나 생성자같은 것을 정의하는 곳이다.  

Strict mode  
클래스 선언과 클래스 표현식에서의 바디들은 strict mode에서 실행된다.

생성자

생성자 메쏘드는 클래스 객체 생성과 초기화를 특별한 mehtod이다.  
클래스내에 "constuctor"라는 단 하나의 특별한 method만으로 가능하다.   
만일 클래스가 하나보다 많은 생성자를 갖고 있다면 SyntaxError가 발생할 것이다.  
생성자는 부모 클래스의 생성자를 부를수 있는 슈퍼키워드를 사용할 수 있다. 

Prototype Method  
  - getter & setter (ES5)  
    a. get문법은 객체 속성에 불려질때 호출할 함수를 묶는다.  

```
{
  get prop() {...}
}
//또는
{
  get [expression]() {...}
}
```

prop는 속성의 이믈으로 주어진 함수가 이곳에 바인딩된다.  
expression은 ES6에서 소개된 것으로 계산가능한 것을 속성의 이름으로 사용할 수 있다.(node 4.1.2에서는 지원하지 않는다.)   

b. set문법은 객체의 속성에 속성을 set하려할때 호출될때 함수를 bind한다.  

```
{
  set prop(val) {...}
}
//ex
var obj = {
foo: "bomb",
     set foo(val) {
       this.foo  = val;
     }
};
obj.foo = 'hi';
//obj.foo가 hi가 된다.
```

- Short syntax  
ES6에서는 객체내 멤버 선언을 짧은 문법으로 가능하다.(get, set과 비슷하다)  

```
  var obj = {
    foo: function() {}
  };
//아래는 같은 코드이다.
var obj = {
  foo(){ }
};
```

static methods  
static키워드는 클래스를 위한 static method를 정의한다.  
static method는 클래스의 초기화, 생성 없이 불려질 수 있다.   

```
class Point {
  constructor(x, y) {
    this.x =x;
    this.y = y;
  };

  static distance(a, b) {
      const dx = a.x - b.x;
      const dy = a.y - b.y;
      return Math.sqrt(dx * dx + dy * dy);
    }
}

const p1 = new Point(5,5);
const p2 = new POint(10, 10);
console.log(Point.distance(p1,p2)); // 7.071..
```

상속  
extends 키워드는 클래스 선언이나 표현식에서 다른 클래스의 자식으로 만들기 위해 사용된다.  

```
class Animal {
  constructor(name) {
      this.name =  name;
  };

  speak() {
    console.log(this.name + ' makes a noise');
  }
};

class Dog extends Animal {
  speak() {
    console.log(this.name  + ' barks.');
  };
};
```

super키워드  
super키워드는 객체의 부모 함수를 호출한다. 상속한 부모 class의 function을 호출할 수 있다.

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes


## 4. Map
key-value이다. object와 다른 점은 property가 없다.  
object는 key만 string이 될 수 있지만 map의 key는 어떤 타입이건 가능하다. 심지어 함수도 가능하다.  
심지어 NaN(Not a Number)도 key로 이용할 수 있다.

## 5.WeakMap
WeakMap 객체는 키-값 쌍의 모음으로 키는 약함 참조이다. 키는 반드시 객체이어야 하고 값은 다 가능하다.  

```
var wmap = new WeakMap([iterable]);
```
   - iterable   
    iterable은 배열 또는 다른 키-값 쌍을 갖는 iterable 객체이다. 각 키-값 쌍은 새로운 WeakMap에 추가될 것이다.  
    null은 undefined로 다뤄진다.

```
var wm1 = new WeakMap(),
    wm2 = new WeakMap(),
    wm3 = new WeakMap();
var o1 = {},
    o2 = function(){},
    o3 = window;

wm1.set(o1, 37);
wm1.set(o2, "azerty");
wm2.set(o1, o2); // a value can be anything, including an object or a function
wm2.set(o3, undefined);
wm2.set(wm1, wm2); // 
```

  - Description
      WeakMap의 키는 Object 타입만 된다. Primitive data type은 되지 않는다.
 WeakMap객체는  object만을 키로 허용하고 값은 임의의 값을 허용하는  키/값 형태의 요소의 집합이다. 키가 가지고
 있는 객체에 대한 참조는 객체에 대한 참조가 더이상 존재하지 않을 경우 garbage collection(GC)의 수거 대상이 되는
 약한 참조를 의미한다. WeakMap API는 Map API와 동일하다. 

 단 한가지  Map객체와 다른 점은 WeakMap의 키들은 열거형이 아니라는 점이다. (즉, 키 목록을 제공해 주는 메서드가
        없다는 것이다.) 만약에 키 목록을 제공한다면 garbage collection의 상태, 결과에 따라 키 목록이 변하게 될 것이다.
        이는 비 결정성을 야기한다. 

## 6. Set
중복 값을 허용하지 않는다. 모든 형태의 값을 가질 수 있다.

## 7. WeakSet
set과 달리 객체만 저장가능하다.

## 8. Symbol

## 9. Template String
기존의 문자열과 달리 \`\`를 이용한다. multi line이 가능하다.  

```
var common_str = 'common str';
var template = `c dt templ
safsda l`; 
```

## 10. Generator
함수과 같다. 다만 선언이 다르고 yield가 있다.
선은은 다음과 같이 한다.
function* name() {};
내부에 yield가 있어 name.next();를 통해 순서대로 yield로 값을 돌려줄 수 있다.(state가 유지된다!)
물론 return도 쓸 수 있다. return이 있으면 아래 yield가 있어도 next로 접근할 수 없다.

## 11. arrow function
파이썬의 람다와 같다.  

```
function (a) {
  return x;
}

//아래는 같은 로직이다.
var f = x=>x*3;

console.log('result %d', f(3)); //9를 출력
```

