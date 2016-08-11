---
layout: post
title: " Spring Boot Controller And Service And Domain "
date: 2016-08-11 02:38:58
categories: spring spring.boot
---

이전 장에 이어 이번에는 로직을 구성할 수 있도록 Domain, Service, Controller를 구성한다.  

## Domain  
Jpa + Hibernate with lombok 도메인의 구현은 다음의 방법으로 이루어진다.  

- Entity 선언  
       
```java
    @Entity
    @Data
    public class User implements Serializable {
      @Id
      @GeneratedValue
      private Long id;

      @Column(unique = true)
      private String username;
      private String password;
      private Date createdAt;
      private Date lastLoginAt;

      @Enumerated(EnumType.STRING)
      private Role role;

    }
```  
    - Entity : Domain임을 의미한다.  
    - Data : lombok을 위한 annotation이다.    
    - Id : table의 pk id임을 의미한다.  
    - GeneratedValue : 자동 생성  
    - Column : 칼럼 설정을 위해 쓰인다.  


- Repository 선언  

```java
public interface UserRepository extends JpaRepository<User, Long> {
  User findByUserName(String username);
  ...
}
```  

JpaRepository를 extends하며 대상 Enitty와 Entity의 pk id의 type을 써준다.  
이후에는 사용할 method 를 정의해 주면 된다.  


## Service  
서비스는 더욱 간단하다. Class에 @Service annotation만 붙이면 된다.  

```java
@Service
public class UserService {

}
```

@Transactional 도 사용할 수 있다.   


## Controller
Controller도 역시 간단하다. class에 @Controller 혹은 @RestController 를 붙이면 된다.  

```java
@RestController
public class UserContrller {

  @Autowired
  UserSerivce userService;
  
  @RequestMapping(method = RequeseMethod.GET, path = "/user")
  @ResponseBody
  public User info() {
    User user =  userService.getUser("username");

    return user;
  }
}
``` 

이 외에 더 많은 정보는 https://spring.io/ 를 참고하면 된다.  
