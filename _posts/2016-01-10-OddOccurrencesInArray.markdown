---
layout: post
title: " OddOccurrencesInArray "
date: 2016-01-10 15:49:08
categories: node.js codillity
---

## OddOccurrencesInArray  
배열 A는 홀수들을 담고 있다. 배열의 각 요소들은 같은 값을 같는 짝 요소를 하나씩 갖는데 한 한쌍 혹은 한 요소만 짝을 가지 않게 된다.  이때 짝을 갖지 않는 요소를 return하라.  

## Solution   

```javascript
function solution(A) {
  var map = {};
  var unpair;

  A.forEach(function(el, idx) {
      if (map[el] && map[el].length > 0) {
      map[el].pop();
      } else {
      map[el] = [0];   
      }
      });

  for (var key in map) {
    if (map[key].length > 0) unpair = key;
  }

  return parseInt(unpair);
}


```

# References  
- https://codility.com/programmers/task/odd_occurrences_in_array/
