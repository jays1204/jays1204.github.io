---
layout: post
title: " 빌더 패턴 "
date: 2015-11-09 22:02:51
categories: pattern
---

# Builder Pattern
class를 사용하도록 리팩토링을 하던 중 생성자에 argument가 너무 많아 이를 어떻게 하면 깔끔하게 표현할까 고민하며 검색해보니 많은 이들이 빌더 패턴을 추천해주었다.  
빌더 패턴이 무엇인지 알아보고자 한다.  

## 정의 
복잡한 객체의 생성을 표현으로 부터 분리 시키는 것이다. 이로서 같은 생성과정에서 다른 표현을 만들어 낼 수 있다.  
사실 이거 봐서는 이해하기가 힘들다. 

## 구조 
- Builder
  : 객체를 생성하는 인터페이스(자바 스크립트는 인터페이스가 없으므로 안쓴다.)
- Concret Builder
  : Builder의 구현 클래스이다. 실제로 객체를 생성한다. 생성 과정의 데이터를 유지하면서 객체를 만들어 나아간다.
- Director
  : Concret Builder를 인자로 받아서 필요한 동작을 한다. 
- Product
  : Builder를 이용하여 Director가 만들어낸 산출물

## 설명
만들어 낼 결과물의 인터페이스를 Builder에 정의한다.  
이를 Concret Builder가 인자들을 받아서 실제 객체를 만들어내고 만들어낸 객체를 Director에 전달하면 Director가 조건에 맞는 산출물을 내놓는다.  

## example

~~~javascript
class User {
  constructor(builder) { //director
    this.name = builder.name;
    this.age = builder.age;
    this.country = builder.country;
    this.gender = builder.gender;
  };

  static createBuilder(name, age, country) {
    return new Builder(name, age, country);
  }
}

class Builder {
  constructor(name, age, country) {
    this.name = name;
    this.age = age;
    this.country = country;
  };

  setGender(gender) {
    this.gender = gender;
    return this;
  };

  build() {
    return new User(this);
  }
}

var concreteBuilder = User.createBuilder('jays', 29, 'KR');
var manProduct = concreteBuilder.setGender('man').build();
var womanProduct = concreteBuilder.setGender('woman').build();

~~~
concreteBuilder가 말그대로 Concret Builder로서 생성 과정의 기본 값을 유지해 나아가며 표현이 조금 다른 데이터를 추가 한 후 마지막에 build()를 통해 director인 User에 값을 넘겨주어 Product를 생성한다.  
여기서 Product Class를 생략하였다. 

Builder class를 이용하여 '이름, 나이, 국가'가 같은 생성 과정을 갖지만 성별만 다른 product를 만들어 냈다.   

Builder를 통해 기본 값을 갖는 기본 산출물을 만든 후 각 Product에 맞는 값을 설정 후에 이를  Director에 넘겨주어 Product를 만들어 내는 것으로 이해하였다.


### See
http://www.dofactory.com/javascript/builder-design-pattern
