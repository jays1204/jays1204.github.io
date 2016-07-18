---
layout: post
title: " MissingInteger Problem "
date: 2016-01-12 13:51:16
categories: node.js, algorithm
---

## Problem  
배열 A는 N개의 정수를 갖는다. 이때 나타나지 않는 양의 정수 중 가장 작은 것을 구하라.  


## code  
아래는 그리 좋아 보이지 않는다. 케이스도 하나 실패한다.

```javascript
function solution(A) {
  var sorted = A.sort(function(a, b) {
      return a - b;
      });
  var count = 1;
  var answer = 1;
  var notMissing = true;
  var positives = [];

  sorted.forEach(function(num) {
      if (num > 0) positives.push(num);
      });

  for (var i = 0, li = positives.length; i < li; i++) {
    if (positives[i] > count) {
      answer = count;
      notMissing = false;
      break;
    } else {
      count = positives[i] < count ? count : count + 1;
    }
  }

  if (notMissing) answer = positives.length + 1;

  return answer;
}
```


# References  
- https://codility.com/programmers/task/missing_integer
