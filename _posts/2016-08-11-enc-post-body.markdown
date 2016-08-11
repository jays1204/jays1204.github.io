---
layout: post
title: post body encoding
date: 2016-08-11 03:57:12
categories: http encoding
---

# 요즘의 Request

RestFul API를 사용하며 json을 많이 사용하게 됨에 따라 요즈음의 request의 Content-Type은 대부분이 application/json인 것이 많다. 

아니면 파일 첨부를 위해 multipart/*를 사용한다. application/x-www-form-urlencoded는 form에서 default로 사용되는 것 이외에는 사실 잘 사용하지 않는 편으로 보인다.

요새 자주 사용하지 않지만, 하지만 여전히 application/x-www-form-urlencoded를 사용하는 경우가 존재한다.

Content-Type이 다름에 따라 뭐가 달라지겠느냐 하겠지만 다른 점이 분명히 있다.

application/json이 {key:value}의 형태로 전송되며 application/x-www-form-urlencoded가 key-value&key=value...의 형태로 전송되는것 외에도 데이터의 압축 여부 등의 size 차이등(file을 전송할 때 왜 multipart/formed-data를 사용할까? 다른 Content-Type을 사용하면 파일 전송이 안될까? 인코딩후 사이즈 차이다.)의 차이점이 존재한다.

그중 하나의 차이점으로 POST로 보내며 Content-Type이 application/x-www-form-urlencoded의 body encoding을 생략할 시 나타나는 문제점이다.

우선 Browser에서는 알아서 body를 인코딩해서 보내주는 것으로 보인다. (많은 브라우저가 W3를 충실히 따르는 것 같다.)

문제는 개발자가 직접 request를 코드로 작성할 떄이다. 

이를 위해 우선 Content-Type에 대해 간단하게 알아보자.


# Content Type

우선 Content-Type에 대해 알아보자.

HTTP Header에 쓰이는 Content-Type이란 무엇일까?

request에 실어 보내는 데이터(body)의 type의 정보를 표현한다. 

Text타입으로는 text/css, text/javascript, text/html, text/plain등이 있다. 

html문서에 type을 명시할 때 text/javascript 혹은 text/css를 이미 써봤으리라 생각한다. 

File을 실어보내기 위한 타입으로는 multipart/formed-data가 있다. 

그리고 Application 타입으로 application/json, application/x-www-form-urlencode가 있다. 

Content Type은 Request에 실어 보내는 data의 type에 따라 적절하게 선택을 해주면 된다.

이쯤에서 Content Type의 설명은 간략하게 된거 같다. 더 자세하게 내용을 알고싶다면 W3의 다음 페이지를 참고하기 바란다. http://www.w3.org/Protocols/rfc1341/4_Content-Type.html

# 그래서 결론이 뭔데?

다시 본론으로 돌아와 보자. application/x-www-form-urlencoded를 사용할 때 body를 encoding 하는 것이 필수인가?
그에 대한 답은 W3에 있는 문서에 나와 있다.

* application/x-www-form-urlencoded  
This is the default content type. **Forms submitted with this content type must be encoded as follows:** *
1. Control names and values are escaped. Space characters are replaced by `+', and then reserved characters are escaped as described in [RFC1738], section 2.2: Non-alphanumeric characters are replaced by `%HH', a percent sign and two hexadecimal digits representing the ASCII code of the character. Line breaks are represented as "CR LF" pairs (i.e., `%0D%0A').
2. The control names/values are listed in the order they appear in the document. The name is separated from the value by `=' and name/value pairs are separated from each other by `&'


encoding을 해야 한다고 나온다. 브라우저에서는 아마 대부분 기본적으로 해당 content-type에 대해 자동으로 encoding하도록 구현을 해놓았을 것이다.

따라서 우리가 주의해야 할 것은 하나다. application logic에서 applcation/x-www-form-urlencoded를 사용할 경우 body 인코딩이 해당 framework 혹은 library에서 자동으로 되는지 확인 후 안되면 해줘야한다.

아래와 같은 경우로 코드를 만들경우에는 조심해야 한다.

```java
HttpClient client = new HttpClient();
//blah blah...
PostMethod method = new PostMethod("targetUrl");
method.getParams().setContentCharset(charSet);
method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler(3, false));
method.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset="+ charSet);
```

한가지로 예제로 node.js의 request 라이브러리는 해당 Content-Type에 대해 qs.stringify로 url인코딩하도록 이미 내부에 구현이 되어있다.

```javascript
Request.prototype.form = function (form) {
if (form) {
this.setHeader('content-type', 'application/x-www-form-urlencoded; charset=utf-8')
this.body = qs.stringify(form).toString('utf8')
return this 
}
// create form-data object
this._form = new FormData()
  return this._form
  }
```



- 이글은 https://gist.github.com/jays1204/703297eb0da1facdc454 에 있는 글을 현재 블로그로 옮겨온 글이다. 
