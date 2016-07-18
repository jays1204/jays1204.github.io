---
layout: post
title: " Perm Check Problem "
date: 2016-01-12 15:19:30
categories: node.js, codillity
--- 

## Problem  
배열 A의 원소들이 순열인지 아닌지 구하라.  

## Solution  

```javascript
function solution(A) {
  var sorted = A.sort(function(a, b) {
      return a - b; 
      });
  var isPerm = 1;
  for (var i = 0, li = sorted.length; i < li; i++) {
    if (sorted[i] != (i + 1)) {
      isPerm = 0;   
      break;
    }
  }

  return isPerm;
}
```

# References  
- https://codility.com/programmers/task/perm_check/
