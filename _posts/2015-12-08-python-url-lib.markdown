---
layout: post
title: " python url library "
date: 2015-12-08 23:58:06
categories: python
---

# Python url library

## urlparse
urlparse는 url의 분해, 조립등의 기능을 제공한다.  

```python
from urlparse import urlparse
result = urlparse("https://www.google.co.kr/?hl=ko&gws_rd=cr,ssl&ei=ZfBmVvvkCMTimAXz4rGwCQ")
print result
``` 

출력 결과는 아래와 같다.

```bash
$ ParseResult(scheme='https', netloc='www.google.co.kr', path='/', params='',
query='hl=ko&gws_rd=cr,ssl&ei=ZfBmVvvkCMTimAXz4rGwCQ', fragment='')
```

schema는 protocol, netloc은 host:port, path는 uri를 의미하며 나머지는 기본적으로 쓰이는 http 명세와 의미가 같다.  

## urlopen

```python
urlopen(url, data=None, [timeout])
```

url에 대해 연결을 한다. 기본은 GET이다. 

urlopen을 통해 가져온 연결에 대해 read를 이용해서 값을 가져올 수 있다.   
POST 방식으로 요청을 하고 싶다면 data에 값을 넣어주면 POST로 요청한다.  
header를 설정하여 요청을 보내고 싶다면 urllib의 request객체를 url인자에 넣으면 된다.  

```python
req = urllib2.Request("http://www.naver.com")
req.add_header("Content-Type", "application/json")
r = urllib2.urlopen(req)
r.read()
```

build_opener를 통해 url에 연결할때 사용할 opener 함수를 설정할 수 있다.  
install_opener는 생성한  opener함수를 현재뿐 아니라 전역적 사용으로 설정할 때 쓰인다.
