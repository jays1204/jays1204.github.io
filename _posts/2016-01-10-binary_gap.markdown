---
layout: post
title: " Max Binary Gap "
date: 2016-01-10 15:39:07
categories: node.js, algorithm, codillity
---

## Max Binary Gap  
문제는 다음과 같다.  
양의 정수가 있을때 해당 수를 2진수로 변환하였을 때 1사이에 연속적으로 보이는 0을 binary gap이라 한다. binary gap은 하나 이상 혹은 없을 수도 있다.  
양의 정수가 주어질 때 가장 긴 길이를 가진 binary gap의 길이를 return하라.  
만일 binary gap이 존재하지 않는 다면 0을 return하라.  

- 세부 조건  
  1. 수의 범위는 1부터 2,147,483,647까지이다.  
  2. 최악 복잡도는 O(log(N))  
  3. 최악의 공간 복잡도는 O(1)  

## Solution  

```javascript
function solution(N) {
    // write your code in JavaScript (Node.js 4.0.0)
        
  var binary = (N >>> 0).toString(2); //2진수를 구한다. 
  var gaps = binary.split(/1/); 

  gaps.shift(); //1로 split하였으므로 첫 배열은 항상 빈 값이므로 버린다. 

  var lastIdx = gaps.length - 1;
  if (gaps[lastIdx][gaps[lastIdx].length - 1] === '0') {
    gaps.pop();
  }

  if (gaps.length === 0) return 0;

  return Math.max.apply(null, gaps.map(function(el) {
        return el.length;
  }));
}
```




## References  
- https://codility.com/programmers/task/binary_gap
