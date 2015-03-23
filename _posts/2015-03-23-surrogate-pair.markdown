---
layout: post
title:  "Surrogate Pair"
date:   2015-03-23 23:06:22
categories: encoding charset
---

# Surrogate Pair
  - Surrogate pair란 무엇인가에 대해 간략히 정리한다.
  우선 문자를 표현하기 위해 우리는 유니코드를 사용한다. 이 유니코드의 모음이 있으며 이 모음을 유니코드 스페이스라고
  한다. 유니코드 스페이스는 총 17개의 평면이며 각 평면은 2의 16제곱 개의 코드 포인트라 불리는 유니코드의 값과 이름으로
  구성된다. 이중에는 아직 할당이 되지 않은 코드 포인트, 개인적으로 사용되는 코드 포인트, 영구적으로 사용 못하는 코드
  포인트가 존재한다. 이 17개의 평면중 첫번째 평면을 BMP(Basic Multilingual Plane)이라고 한다. U+0000부터 U+FFFF까지
  있으며 가장 빈번하게 사용되는 문자들이 속해있다. 나머지 16개의 평면은 supplementary plane 혹은 astral plane이라고
  한다. 중요한건 유니코드 스페이스는 BMP와 BMP가 아닌 것으로 이루어졌다는 것이다.
  - Surrogate pair는 두개의 쌍으로 이루어진 문자이다.
  보통 자바스크립트는 UTF-16을 사용하는데 UTF-16은 16비트를 한글자로 표현한다. BMP안에 있는 문자의 경우 16비트 코드
  하나로 표현이 가능하지만 밖에 있는 문자중 16비트 코드 두개를 이용하여 표현해야 하는 문자가 있다. 이렇게 16비트 코드
  두개를 사용하여 문자 하나를 표현한 것을 surrogate pair라고 하며 앞의 것을 high surrogate, 뒤의 것을 low surrogate라
  한다. 
  - 어떨때 문제가 되나?
    가장 간단한 문제는 CJK이다. 그중에서도 중국어 즉 한자이다. 한자의 경우에는 많은 글자가 BMP외부에 있고 이중에는
    surrogate pair로 표현되는 한자들이 존재한다. 𨨏 한자의 경우 javascript 혹은 node.js에서 length를 구하면 2이다.
    surrogate pair이기때문에 length가 2로 나오는데 문제는 length로 substr할 경우 운이 없게도 high만 남고 low가 잘리는
    경우가 생길 수 있다. 이럴경우에 encodeURI를 할경우 malform URI가 발생하므로 주의해야 한다.

# 참조
https://mathiasbynens.be/notes/javascript-encoding
