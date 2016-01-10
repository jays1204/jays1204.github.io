---
layout: post
title: " PermMissingElem "
date: 2016-01-10 16:09:14
categories: {{node.js, codillity}}
--- 

## PermMissingElem  
배열 A는 N개의 다른 정수로 이루어져 있다.  배열의 요소는 [1..(N+1)]의 범위에 속해있다.  이것은 배열 A에 정확히 [1, N+1] 중에 정확히 하나가 빠져있음을 의미한다.  
이때 빠진 하나를 찾아야 한다.  


## Solution 

```javascript
function solution(A) {
  var N = A.length;

  var sorted = A.sort(function(a, b) {
      return a - b; 
      });
  var idx = 0;
  var missing;

  for (var i = 1; i <= N+1; i++) {
    if (i != sorted[idx]) {
      missing = i;
      break;
    } else {
      idx++;   
    }
  }

  return missing;
}

```

# References  
- https://codility.com/programmers/task/perm_missing_elem

