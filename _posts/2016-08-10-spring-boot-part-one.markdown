---
layout: post
title: " Start With Spring boot "
date: 2016-08-10 11:22:46
categories: spring spring.boot 
---

## Web Application With Spring Boot
신규 프로젝트를 위해 spring boot by gradle 조합으로 개발을 시작하였다.  

gradle은 sdk-man을 통해 설치 가능하다.

```sh
sdk install gradle 2.14.1
```

gradle 설치가 끝났다면 다음 IntelliJ 페이지를 참고하여 Spring Initializr로 스프링 부트 프로젝트를 시작한다.  
https://www.jetbrains.com/help/idea/2016.2/creating-spring-boot-projects.html

이 프로젝트에서는 다음의 옵션을 선택하였다.  
  - Security  
  - Session  
  - Cache  
  - Lombok  
  - Web  
  - Thymeleaf  
  - JPA  
  - JDBC  
  - MYSQL  
  - Redis  
  - Validation

나의 경우에는 project를 생성 후 IntelliJ에서 gradle 프로젝트로 인식하지 못하였다. 
이때에는 build.gradle에 다음의 plugin을 추가해준다.

```groovy
apply plugin: 'idea'
``` 

이후 gradle idea task 실행 후 프로젝트를 다시 open하면 IntelliJ에서 gradle project로 인식한다.


## 기본 설정  
- DB 설정 
  application.properties 에 DB 연결을 위한 다음의 설정을 추가한다. 
  jpa, hibernate를 이용하여 mysql에 연결하는 설정이다.  

  ```
  spring.jpa.hibernate.ddl-auto=create #
  spring.jpa.generate-ddl=false #
  spring.jpa.show-sql=true #

  spring.datasource.url=jdbc:mysql://localhost:3306/demoapp
  spring.datasource.username=username
  spring.datasource.password=password
  spring.datasource.driverClassName=com.mysql.jdbc.Driver
  ```

- host swap 설정  
  class 수정 후 app을 다시 실행이 아닌 즉시 반영을 위한 설정이다. 꼭 필요하지는 않다.  
  spring-loaded 라는 플러그인을 이용한다.  
  다음의 설정을 build.gradle에 추가한다.   

  ```groovy
  buildscript {
    ...
    dependencies {
      ...
      classpath 'org.springframework:springloaded:1.2.4.RELEASE' //for hot-swap
      ...
    }
    ...
  }
  ```

해당 설정을 추가한 후 app을 실행 시에는 ~Application.java로 실행하는 것이 아니라 gradle의 task중 하나인 bootRun으로 실행한다.  
hot-swap을 사용하기 위해서는 class를 수정 후 컴파일만 해주면 즉시 반영이된다.

## Spring Application
spring boot의 application의 main은 다음과 같이 구성된다. 

```java  
@SpringBootApplication
public class DemoBootApplication {

  public static void main(String[] args) {
    ApplicationContext ctx = SpringApplication.run(DemoBootApplication.class, args);
  }

}
```  

여기서 SpringBootApplication annotation은 다음의 annotation을 포괄한다.   

  - @Configuration : application context의 bean 설정 클래스임을 의미  
  - @EnableAutoConfiguration :  다양한 설정들에 의한 Bean을 추가하도록 한다.  
  - @EnableWebMvc : Web application 활성화    
  - @ComponentScan :  패키지안에서 다른 설정, 컴포넌트, 서비스등을 찾도록 하게한다.  


## Login By Spring Security
이제는 앱을 띄웠으니 가장 기본 기능인 Login을 구현할 차례이다.
로그인은 spring-security를 이용하여 진행한다.

SpringSecurity를 진행하기 위해 WebMvcConfigurerAdapter를 상속받는 class를 생성한다.  (아무데나 생성해도 상관없다.)

```java

@Configuration
public class MvcConfig extends WebMvcConfigurerAdapter {

  @Override
    public void addViewControllers(ViewControllerRegistry registry) {
      registry.addViewController("/home").setViewName("home");
      registry.addViewController("/").setViewName("home");
      registry.addViewController("/hello").setViewName("hello");
      registry.addViewController("/login").setViewName("login");
    }
}

```  
특정 url로 접근할시에 특정 static page로 연결시켜주는 설정이다.  
여기서는 시작페이지, 로그인 페에지, 로그인 성공시 보여줄 페이지를 설정하였다.  

이번에는 로그인 및 권한 관리를 위한 WebSecurityConfigurerAdapter를 상속받는 SecurifyConfig class를 만든다.

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

  @Autowired
  private CurrentUserDetailsService currentUserDetailsService;

  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.authorizeRequests()
      .antMatchers("/c/**", "/j/**", "/i/**", "/resources/**", "/webjars/**").permitAll();

    http.authorizeRequests()
      .antMatchers("/jays").permitAll()
      .anyRequest().fullyAuthenticated()
      .and()
      .formLogin()
      .loginPage("/login")
      .permitAll()
      .defaultSuccessUrl("/home")
      //                    .successForwardUrl("/home")
      .failureUrl("/jays")
      .and()
      .logout()
      .logoutSuccessUrl("/login")
      .invalidateHttpSession(true)
      .permitAll();


  }

  @Autowired
  public void configure(AuthenticationManagerBuilder auth) throws Exception {
    auth.userDetailsService(currentUserDetailsService);
  }

  @Bean
  public AuthenticationSuccessHandler successHandler() {
    return new CustomLoginSuccessHandler("/home");
  }
}

```  

Spring Security를 사용하기 위해서는 @EnableWebSecurity annotation을 반드시 사용해야 한다.  

Http 요청에 대한 security를 적용하기 위해서는 다음의 method를 override한다.  

```java  
protected void configure(HttpSecurity http);
```

아래는 위의 method의 override 구현이다.  

```java
@Override
protected void configure(HttpSecurity http) throws Exception {
  http.authorizeRequests()
    .antMatchers("/c/**", "/j/**", "/i/**", "/resources/**", "/webjars/**").permitAll();

  http.authorizeRequests() 
    .antMatchers("/jays").permitAll() // /jays url은 모두가 접근 가능
    .anyRequest().authenticated() // 나머지 url에 대해서는 인증받지 않았으면 접근불가
    .and()
    .formLogin() // form login을 가능하게 한다.
      .loginPage("/login") // login page의 주소는 /login이다.
      .permitAll() // 모든 사용자가 접근 가능하다.
      .defaultSuccessUrl("/home") 
      .failureUrl("/jays")
    .and()
    .logout() // logout 설정을 한다.
      .logoutUrl("/logout") // logout url 설정
      .logoutSuccessUrl("/login?logout") // logout성공시 redirect url
      //.logoutSuccessHandler(logoutSuccessHandler) // 이 설정이 있으면 logoutSuccessUrl은 무시된다. 
      .invalidateHttpSession(true) // logout시 세션을 날린다. 
      //.deleteCookies(cookieNamesToClear)  // logout시 쿠키를 삭제한다.
      .permitAll();
}

```  

위 설정은 다음과 같다.   

  - /c, /j/, /i/, /resources, /webjars 로 시작하는 url에 대해서는 누구든 접근을 허용한다.  
  - /jays에 대해서도 항상 허용한다.   
  - 다른 reuqest에 대해서는 모두 인증된 사용자여야 접근이 가능하다.   
  - formLogin을 허용한다.   
  - logout이 성공하면 /login 페이지로 리다이렉트하고 session을 삭제한다.  

and()는 xml 표현식에서 닫는 표현식의 역할을 한다. 

- 인증 설정  

```java
@Autowired
public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
  auth
    .inMemoryAuthentication()
    .withUser("jays").password("1234").roles("USER");

}
```  
AuthenticationManagerBuilder를 이용하여 인증을 설정할 수 있다.   
위의 코드는 jays 사용자가 1234 비밀번호를 치고 들어오는 경우 USER 롤을 주는 것을 의미한다.  

여기까지 한 후 실행하면 http://localhost:8080/login에서 jays/1234를 통해 로그인 할 수 있고 성공한다면 localhost:8080/으로 리다이렉트된다. 

또는 AuthenticationProvider를 이용하여 custom한 인증을 구현할 수 있다.  



## AuthenticationProvider  
userDeatailsService가 아닌 조금더 custom한 로그인을 구현하기 위해 AuthenticationProvider를 이용한다.   

SecurifyConfig 클래스에서 이전에 userDetailsService를 사용한 부분을 authenticationProvider로 바꾸어주면 된다.  

```java

@Autowired
@Qualifier("authenticationProvider")
AuthenticationProvider authenticationProvider

... 

@Autowired
public void configureGlobal(AuthenticationProvider auth) throws Exception {
  auth.authenticationProvider(authenticationProvider);
} 

...

``` 

이후 AuthenticationProvider를 implements하는 Class를 만들어준다.  

```java
@Component("authenticationProvider")
public class LdapAuthenticationProvider implements AuthenticationProvider {

  @Autowired
  private UserService userService;

  @Autowired
  private UserRepository userDao;


  @Override
  public Authentication authenticate(Authentication authentication) throws AuthenticationException {
    String username = authentication.getName();
    String password = (String) authentication.getCredentials();

    User user;
    ...
    //find user object

    ...
    currentUser = new CurrentUser(user);

    return new UsernamePasswordAuthenticationToken(currentUser, password, currentUser.getAuthorities());
  }

  @Override
  public boolean supports(Class<?> authentication) {
    return true;
  }

}
```  

authenticat를 구현한다. 로그인 시에 요청된 사용자의 이름과 비밀번호 등을 이용하여 로그인을 처리한다.  
이때 올바른 로그인이라면 UsernamePasswordAuthenticationToken를 생성하여 return한다.    
supports는 authenticate를 거친 결과 값이 AuthenticationProvider에서 사용할수 있는 값이면 true를 return한다.  


## Redis session 적용  
이제 login session을 redis에 저장하여 이용하는 설정을 한다.   
다음의 설정을 SecurifyConfig에 추가해주면 해당 Class에는 @EnableReidsHttpSession annotation을 추가한다.  

```java
@Bean
public JedisConnectionFactory connectionFactory() {
  return new JedisConnectionFactory();
}

```

## References
  - https://spring.io/guides/gs/spring-boot/
  - http://blog.saltfactory.net/java/creating-springboot-project-in-intellij.html
  - http://blog.saltfactory.net/java/developing-spring-without-restarting-server.html
  - http://docs.spring.io/spring-security/site/docs/current/reference/html/jc.html
  - http://netframework.tistory.com/entry/Code-Base-Spring-Security-%EA%B8%B0%EB%B3%B8
  - https://spring.io/guides/gs/serving-web-content/
  - http://kielczewski.eu/2014/12/spring-boot-security-application/
  - https://docs.spring.io/spring-security/site/docs/3.2.6.RELEASE/apidocs/org/springframework/security/authentication/AuthenticationProvider.html
