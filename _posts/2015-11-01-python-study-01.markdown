---
layout: post
title:  python algorithm study 01
date:   2015-11-01 23:45:00
categories: python
---

# Python Study 01
node.js만 하다보니 다른 랭귀지를 전혀 못보는 까막눈이 되어 다른 랭귀지도 공부하고 알고리즘도 다시 볼겸 책을 사서 공부하기로 시작했다.  
책 제목은 <파이썬으로 배우는 실전 알고리즘>  

## ch 01 python summary
파이썬의 자료형은 type() 함수를 통해 알 수 있다.  

- int  

```sh
>>> a = 3
>>> print type(a)
<type 'int'>
```

- float

```sh
>>> a = 3.14
>>> print type(a)
<type 'float'>
```

- str

```sh
>>> a = 'hellp'
>>> print type(a)
<type 'str'>
```

- int는 32비트, long은 대부분을 저장할 수 있다.

## 2의 보수
주어진 2진수보다 한 자리 높되 첫 자리만 1이며 나머지는 모든 0인 수에서 주어진 수를 빼었을때 나오는 수를 의미한다.

## divmod(a, b)
다음의 tuple 값을 리턴한다. (a를 b로 나눈 값, a를 b로 나눈 나머지)

## 부동 소수점
내부적으로 x = +m2^e or x = -m2^e 로 나타낸다고 한다. 이때 m을 가수 2를 밑수, e를 지수라 한다.  
가수는 [1,2) 혹은 0의 값을 갖는다.  
예를 들어 0.5를 위 표현식으로 한다면 1 * 2 ^ -1 이다.    
지수 차이로 인한 비트 이동으로 인해 계산 값이 달라질 수 있다. 따라서 정확한 계산을 위해서 Decimal모듈을 이용하여 계산한다. 

## 복소수
허수 부분을 j로 이용해서 나타낼 수 있다.   

```python
a=1+2j
```

## 문자열
ASCII문자열과 유니코드 문자열을 지원한다.  
""" """은 여러줄을 감싼다. es6의 ``와 같다.  

```python
'a'
"a"
'''a'''
"""afdsa
fsdf
bs"""
```

ASCII을 unicode로 인코딩할 수 도 있다.  

```python
str = 'This is ASCII'
uni = str.encode('utf8')
```

unicoe는 ASCII의 상위 집합이다.  
문자열을 나타날때 str, repr이 있는데 현재로서는 안봐도 될거 같다.  

## Array & List
둘이 비슷하다.  

```sh
>>> a = [1,2,3]
>>> print type(a)
<type 'list'>
```

- append(x)  
  리스트의 맨 끝에 x를 추가한다.
- insert(i, x)  
  리스트의 i번째 위치에 x를 추가한다. 
- del list[idx]  
  리스트의 idx 요소를 삭제한다. 
- len(list)  
  리스트의 element 개수를 돌려준다. 
- reverse()  
  리스트의 element 정렬을 반대로 한다.
- count(x)  
  리스트의 x의 개수를 돌려준다. 
- index(x)  
  리스트내 첫 번째 x의 index를 돌려준다. 
- list[a:b]  
  리스트의 a index부터 b index 전까지를 돌려준다. a 혹은 b 중 하나가 없다면 최소 index, 최대 index를 사용한다. 
- list + list  
  두 개의 리스트를 연결한다.
- sort()  
  리스트를 정렬한다. ASC이다.

반복문에서 사용 가능하다.  
array는 다음을 통해 사용가능하다.  

```python
from array import array
``` 

배열은 모든 항목이 같은 자료형이어야 한다.   

```sh
>>> from array import array
>>> b = array('d', [1,2,3,4,5])
>>> b.append('c')
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  TypeError: a float is required
```
  
array(자료형, [])로 생성한다.  
자료형은 'd', 'l', 'f', 'c'등이 가능하다. 각 자료형의 앞글자이다.  
리스트 보다 배열이 더 빠르다고 한다.  

## Tuple
튜플은 리스트와 비슷한데 크기와 항목 변경이 불가한 녀석이다.  
다음과 같이 선언 가능하다.  

```sh
>>> a = 1,2,3
>>> a = (1,2,3)
>>> a = ()
```

다만 element가 하나이면 tuple로 생성되지 않는다. 
이럴때는 아래와 같이 하면 된다.   

```sh
>>> a = (1,)
```

tuple도 반복문에서 사용이 가능하다.  

## Dictionary
사전은 key-value 객체이다. 
key는 튜플, 숫자, 문자열이 될 수 있다.  

아래를 이용해 key 존재 여부를 검사한다.  

```sh
a = {'key': 1}
>>> 'key' in a
True
```

- keys()  
  해시의 모든 키를 리턴한다.
- values()  
  해시의 모든 값을 리턴한다.  
- items()  
  해시내 키 배열을 튜플로 해서 리스트를 리턴한다.
- update()  
  새로운 key, value를 추가하거나 update(key=value)를 통해 key의 value를 업데이트할 수 있다.  
- del hash[key]  
  해당 key를 삭제한다.

key는 해시가 가능해야 한다.  

## Set
set은 순서가 없으며 중복이 없다. 

```sh
>>> s = set([1,2,3])
```

- add(n)  
set에 n을 추가한다.
- union(set)
  인수 set과 합집합을 구한다.
- intersection(set)  
  인수 set과 교집합을 구한다.
- difference(set)
  인수 set에 대한 차집합을 구한다. 


## Control statement
제어문뒤에 :을 쓰고 다음 행에서 들여쓰기를 하여 제어문 안에 있음을 표현한다.  

```python
i = 0
while i < 3:
  print i
```

do while은 지원하지 않는다.  

```python
a = [0, 1, 'hello']
for i in a:
  print i
```

range(s, e, a)는 s부터 e전까지의 a(기본 1)만큼 증가하는 정수 리스트를 만들어낸다.   
arguement가 하나인 경우에는 0부터 해당 값 전까지를 돌려준다.  

```python
a = range(0,5)
for i in a:
  print a
```

enumerate는 arguement의 (idx, value) 튜플을 생성한다. 

```python
a = ['a', 'b', 0, 1]
for (i, j) in enumerate(a):
  print i, j
```

다른 언어들 처럼 반복문 내에서 continue와 break도 사용가능하다.  

else if를 elif로 쓴다는 것만 빼면 다른 언어와 같다.   
||는 or, &&는 and 로 표현가능하다.  

```python
for i in range(3):
  if i == 0:
    print 'zero'
  elif i == 1:
    print 'one'
  else:
    print' other'
```

try catch  

exception을 잡을 부분을 try 로 감싸고 exception 처리 부분을 선언하고 항상 호출될 부분은 finally에 선언한다.  

```python
try:
  a = 1/0
except Exception, e:
  print 'oops: %s' % e
else:
  print 'no problem'
finally:
  print 'done'
```

에러도 여러 종류가 있다.  
상위 Error는 Exception이 있고 그 아래 SyntaxError, ValueError 등이 있다. 

## Function
함수는 def로 선언한다.  

```python
def func():
  return 1
```

아래는 기본 값을 갖는 함수이다.  

```python
def sum(a, b=4):
  return a+b
```

상황에 따른 인수개수 조절도 가능하다.  

*는 고정된 인수이외에 값이 전달되면 받는 부분이고 **는 이름이 지정된 식별자 값이 전달된 경우를 의미하며 맨 마지막에 선언되어야 한다.  

## Lambda
람다는 이름없는 함수를 저으이할 수 있다.  
lambda [a]:[b]는 인수는 a이고 b를 반환하는 함수를 정의하는 것이다.


```python
a = lambda b: b+2
```
