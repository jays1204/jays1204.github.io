---
layout: post
title: " MaxCounters "
date: 2016-01-13 14:30:19
categories: node.js codillity
---

## Problem  
N개의 카운터가 있고 카운터는 0으로 초기화 되어있다.   
배열 A는 M개의 요소를 갖는다. 이때 i번째 요소의 값이 [1, N]이라면 i카운터의 값을 증가 시킨다.  
값이 N보다 크다면 카운터의 모든 값을 카운터중 최대 값으로 세팅한다.  
배열 A를 첫번째 부터 끝까지 돌았을때 반환되는 카운터를 구하라.  

최악 시간 복잡도는 O(N+M), 공간 O(N)이다.  

## Solution  

  - O(N * M)   

```javascript
function solution(N, A) {
  var max = 0;
  var counter = (new Array(N + 1)).fill(0);
  var idx;

  while(idx = A.pop()) {
    if (idx === N + 1) {
      if (counter[idx] < max) counter[idx] =
        counter = new Array(N + 1).fill(max);
    } else {
      counter[idx] = counter[idx] ? counter[idx] + 1 : 1;
      max = counter[idx] > max ? counter[idx] : max;
    }
  }

  counter.shift();
  return counter;
}
```  

  - O(N)  
  http://julienrenaux.fr/2015/04/27/codility-efficient-algorithm-solutions-in-javascript/#MaxCounters 참고

# References  
- https://codility.com/programmers/task/max_counters/  
- http://julienrenaux.fr/2015/04/27/codility-efficient-algorithm-solutions-in-javascript/#MaxCounters
