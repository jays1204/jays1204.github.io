---
layout: post
title: " Nest.js Simple Introduction "
date: 2019-03-31 14:49:45
categories: nest.js typescript
---


# Nestjs Tutorial

## Setup & Scaffolding
```bash
$ npm i -g @nestjs/cli
$ nest new project-name
```

최초 생성시 서버 구조  

- src
  - app.controllers.ts
    - routing 처리를 위한 기본 컨트롤러 파일
  - app.module.ts
    - 서버 앱을 위한 모듈 파일
    - 여러 모듈(controller, providers 등)을 App에 inject하는 부분이다.
  - main.ts
    - 앱의 시작(entry) 파일로 CoreApp을 만들어준다.
    - NestFactory를 이용하여 앱을 만든다. 이때 기반 웹프레임웤을 선택할 수 있다.
      - express.js
	- NestExpressApplication
      - fastify.io
        - NestFastifyApplication: 이 예제에서는 이것을 사용한다.
    - NestFactory.create 를 통해 INestApplication interface를 구현체를 만든다.
    - INestApplication은 웹프레임웤 플랫폼에 종속적이지 않다. 각 프레임웤마다 adapter를 통해 INestApplication 를 구현하도록 되어있다.
  - INestApplication 구현체와 app.module.ts를 통해 만든 app module을 이용해 server appp을 만들어 listen 하는것이 역할이다.
  - 개인적 의견으로 이 entry에서 cluster mode 처리가 포함될 수 있다고 본다.

기본적인 실행은 npm start를 이용한다.  
개발모드로 노드몬을 이용하고자할때는 npm run start:dev 를, inspector 까지 원하면 npm run start:debug 를 이용한다.


## Contoller
주소에 맞는 Http request를 받는 라우팅 처리가 목적인 부분이다. `@Controller` decorator를 통해 구현한다.  
class의 선언 바로 위에 @Contoller를 붙여준다.

nest 커맨드를 이용하여 손쉽게 controller를 추가할 수 있다.

```bash
$)  nest g controller users ./ctrls  #app.modules.ts 에도 자동으로 생성된 컨트롤러 정보를 추가해준다.
```

레이어 구분을 위해 우선 컨트롤러는 항상 src/ctrls 에 위치하도록 하였다.

```javascript
import { Controller, Get, Query } from '@nestjs/common';

@Controller('users')
export class UsersController {

 @Get("/")
 users(): object[] {
  return [];
 }

}
```

@Contoller("urlPeifx") 로 선언한다.
세부 method마다 HTTP method와 추가적인 url 지정이 가능하다.
@Get("url")

위의 users가 문제 없이 동작하면 client가 호출시 기본적으로 200의 HTTP 응답과(POST는 201이 기본) json으로 만들어진 body를 응답할 것이다.
응답 코드를 변경하고 싶다면 @HttpCode 를 이용하면 된다.


`주의점은 위와 같은 형태와 라이브러리에 의존적인 @Res 선언 등을 이용해 처리하는 것을 동시에 하지 말아야 하는 점이다.`

Request 데이터에 접근하기 위해서는 routing method의 인자에 다음의 decorator들을 이용하여 접근할 수 있다.  

- @Request()
- @Response ()
- @Body(key?: string)
- @Query(key?: string)
- @Param(key?: string)

예제 

```javascript
   @Get("/")
   users(@Query() gender: string): object[] {
   	....
   }
```

Path variable과 응답 Header 지정 역시 가능하다. 

ex)  

```javascript
  @Get("/:uid")
  @Header('Cache-Control', 'none')
  eachUser(@Param() params): object {
    return [{"id": params.uid,"name":"test","text":"2"}];
  }
``` 


데코레이터 추가시에는 `@nestjs/common` 에서 import함을 잊어선 안된다.

참고로 routing 주소는 파일의 위에서 아래로 우선순위를 갖는다.

또한 nest의 controller의 기본 리턴은 Rx의 observable stream이다.
리턴 타입을 Promise로 사용할 수도 있다.

```javascript
@Get()
async findAll(): Promise<any[]> {
  return [];
}
```

Post 요청에 대한 Body class 처리

Post 요청을 받았을때 body 데이터를 바로 class로 매핑하는 기능이 존재한다.
이를 위해 우선 src/dto 라는 director를 생성하고 User 클래스를 만든다.

```bash
$) nest g class user dto
```



## Provider
service, factory, repository, helper 등의 Nest의 많은 클래스들은 Provider로 취급된다.  
Provider의 주요 컨셉은 Dependency Injection 을 한다는 것이다.  
@Injectable 데코레이터를 붙여서 Provider 클래스를 만들 수 있다.


### Service
provider중 하나인 서비스다.  
서비스를 만들어서 관라히기 위해 src/services 를 만들었다.  
그리고 userService를 생성한다.

```bash
$) nest g service userService services
```

위를 통해 만들어진 userService 클래스는 `@Injectable` 데코레이터를 사용한다.  
`@Injectable` 데코레이터는 메타 데이터를 덧붙여서 Nest에게 이 클래스는 Provider 라고 알려준다.

이 예제에서는 UserService를 위해 User 라는 interface를 사용할 것이다.

```typescript
export interface User {
  name: string;
  age: number;
  gender: string;
}
```

이제 UserController에서 UserService Provider를 호출하여 사용할 것이다.
다음과 같이 선언한다.

```typescript
@Controller('users')
 export class UsersController {
   constructor(private readonly userService: UserServiceService) {};
   ....
```

여기서 `private readonly`를 사용한 의미는 userSErvice의 선언과 해당 서비스의 member를 초기화 해주기 위함이다.

### Dependency Injection
DI에 대한 자세한 설명은 [Anguar DI](https://angular.io/guide/dependency-injection)를 참고하기 바란다.

위에서의 예제를 사용하여 설명하면, Nest에서는 UserService의 instance로 만들어진 userService가 사용되어지는데 이것은 보통 싱글톤이다.  
이 dependency에 대한 결정은 Contoller Constructor에서 된다.  
바로 위 예제에서 보았던 아래 코드이다.

```typescript
@Controller('users')
export class UsersController {
  constructor(private readonly userService: UserServiceService) {};
  ...
```

풀어서 이야기하자면 위의 코드에서 UserService가 인스턴스화되는데 이때 어떤 구현체로 인스턴스화 될지도 선택된다는 것이다.


### Scope
Provider는 생애주기를 의미하는 Scope를 갖는다.  
이것은 보통 앱의 라이프 사이클과 동기화 되어 사용된다.  
앱이 실행되면 모든 dependency가 처리되어 instance화 될것이다. 그리고 앱을 셧다운 시킬때면 각 provider들은 파괴(destroyed)될것이다.  
Provider의 Scope은 변경가능하다.  

- 기본은 SINGLETON으로 앱과 생명주기를 같이하지만 이를 request 베이스로도 변경할 수 있다.  

```typescript
    @Injectable({ scope: Scope.REQUEST })
    export class CatsService {}
```

- 위와 같은 REQUEST 스코프를 사용하면 성능에 영향을 끼칠 수 있으니 주의하기 바란다.


### Custom Provider
Provier를 올릴때 여러가지 추가적인 설정이 가능하다. [자세한 설명](https://docs.nestjs.com/fundamentals/custom-providers)  

- useValue : useValue를 이용하여 특정 상수를 주입시, 생성자를 통해 넣을 수 있다.
- useClass : 이 속성을 이용하면 조건에 따라 다른 Class를 Provider로 사용하도록 할 수 있다. 예를 들면 설정 값을 Porivder로 만들어서 개발 환경에 따라 이를 골라 사용할 수 있게 한다.


### Interface의 역할
Spring을 통해 DI를 접한 사람들이라면 위의 글을 읽으면서 의아한 점이 있었을 것이다.
Spring에서는 Interface와 이에 대한 구현체들을 만들어두고 런타임시에 Interface에 대한 구현체를 주입하는 형태를 취한다.
그런데 위의 설명에서 Interface는 DTO를 정의하는데에만 쓰였다.

본론부터 말하면 타입스크립트에서 interface를 통한 DI는 지원되지 않는다. 언어의 제약 조건으로 인한 것이다. [자세한 설명](https://github.com/nestjs/nest/issues/43#issuecomment-300092490)
그리고 타입스크립트에서 Interface의 목적은 type chekcing을 위해서 사용된다.


## Module
`@Module` 데코레이터가 붙어 있는 클래스로서 애플리케이션의 구조를 정의하는 클래스라고 보면 된다.  
App은 적어도 하나의 Module을 가져야 한다. 이를 root module이라 할 것이다.  
`@Module` 데코레이터는 하나의 object를 인자로 받는데 object는 다음의 키를 갖는다.  

- providers: 해당 module에서 사용할 provider들의 목록을 정의한다.
- controllers: controller의 목록을 정의한다.
- imports: 이 module에서 사용할 외부 module에 정의된 provider의 정보이다.
- exports: 이 module에서 쓰이는 provider의 subset으로 다른 module에서도 사용가능하게 해주기 위한 역할을 한다.

```bash
$) nest g module cats
```
위와 같은 커맨드를 통해 cats.module.ts 를 만들 수 있다.
cat 모듈을 만든 후 이를 아래와 같이 root module에서 사용하는 형태로 하여 module을 조립하여 app을 구성할 수 있다.

```typescript
import { Module } from '@nestjs/common';
import { CatsModule } from './cats/cats.module';

@Module({
  imports: [CatsModule],
})
export class ApplicationModule {}
```


## Middleware
route handler전에 불려지는 function으로 request, response object에 접근 가능하다. 다음 미들웨어로 넘어가기 위해 next를 사용한다.
기본적으로 express.js의 그것과 같다.

미들웨어의 추가적인 구현은 NestMiddleware interface을 implements 하여 가능하다.
그리고 이를 적용하는 것은 module에서 처리된다.

```typescript
import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { LoggerMiddleware } from './common/middleware/logger.middleware';
import { CatsModule } from './cats/cats.module';

@Module({
  imports: [CatsModule],
})
export class ApplicationModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(LoggerMiddleware)
      .forRoutes('cats');
  }
}
```

module에서 LoggerMiddleware라는 미들웨어를 /cats routes에 한해 적용하는 코드이다.

### Middleware Consumer
`MiddlewareConsumer`는 helper class로 미들웨어 적용을 위해 사용된다.
apply, exclude, forRoute등을 체이닝으로 설정할 수 있다.

아래와 같이 여러개의 미들웨어를 동시에 선언할 수도 있다.

```typescript
consumer.apply(cors(), helmet(), logger).forRoutes(CatsController);
```

module단위가 아닌 앱 단위로도 middleware를 적용할 수 있다.
`INestApplication`의 use를 사용하여 처리한다.


## Exception Filter
response에러를 다루기 위한 Exception filter가 내장되어있다.
아래와 같은 Error를 throw하면 알맞은 HTTP 응답코드와 에러 메세지가 응답된다.

```typescript
@Get()
async findAll() {
  throw new HttpException('Forbidden', HttpStatus.FORBIDDEN);
}
```

### Custom Exception Filter
`ExceptionFilter`를 implement하면서 `@Catch(HttpException)` 데코레이터를 갖는 클래스를 만들어서 커스텀함 Exception Filter를 만들 수 있다.

또한 controller의 method마다 `@UseFilters()`를 이용하여 사용할 필터를 지정할 수도 있다.

그리고 필터의 사용 선언은 가급적 module 단위로 하길 권장한다.

```typescript
import { Module } from '@nestjs/common';
import { APP_FILTER } from '@nestjs/core';

@Module({
  providers: [
    {
      provide: APP_FILTER,
      useClass: HttpExceptionFilter,
    },
  ],
})
export class ApplicationModule {}
```

## Pipe
파이프를 통해 요청이 들어온 값의 형태를 검사하고 원하는 형태로 바꾸는 등의 기능을 처리할 수 있다.

## Guard
인증을 지원하는 기능이다.


## Interceptor
`@Injectable` 데코레이터가 있는 클래스로 `NestInterceptor` interface를 implement하여 구현된다.  
AOP를 가능하게 해주는 기능이다.  

- method의 실행 전후에 특정 로직을 결합시킨다.
- return된 결과의 포맷을 변경해준다.
- throw된 error의 포맷을 변경해준다.
- 함수의 기본 동작에 무언가를 더한다.
- function을 override한다.

Interceptor는 2개의 인자를 갖는 intercept()를 갖는다. 인자중 하나는 `ExecutionContext` 이고 나머지는 CallHandler이다.

- ExecutionContext
`ArgumentsHost`를 확장한 클래스다. getHandler method를 갖는다.
사용될 handler가 어떤 것인지, interceptor를 호출한 클래스가 어떤 클래스인지를 알려준다.

- CallHanlder
`Observable`을 return해야 하며 이 클래스의 `handle` method는 contnext의 마지막에 실행되는 것으로 보인다.
https://docs.nestjs.com/interceptors


### References  
- https://docs.nestjs.com/first-steps
