---
layout: post
title: " TapeEquilibrium Problem "
date: 2016-01-11 13:57:28
categories: node.js codillity
---

## Problem of TapeEquilibrium  
비어있지 않은 배열 A는 N개의 정수로 이루어져있다.  배열의 요소는 테이프의 숫자를 말한다.   
정수 P가 있다고 할때 P는 0 < P < N이고 이 P에 의해 배열 A는 두 개의 비어있지 않은 배열로 나뉜다.  
A[0]~ A[P-1]과 A[P]부터 A[N-1]로 나뉘게 된다.  
나뉘어진 두 배열의 각 합의 차이의 절대 값중 가장 작은 것을 구하라.   
공간, 시간 복잡도는 둘 다 O(N)이다.  

## Solution  

```javascript
function solution(A) {
  var sumList = [];
  var diffList = [];

  for (var i = 0, li = A.length; i < li; i++) {
    if (i === 0) {
      sumList[i] = A[i];   
    } else {
      sumList[i] = A[i] + sumList[i-1];   
    }
  }
  var max = sumList.pop();

  for (var i = 0, li = sumList.length; i <li ;i++) {
    var front = sumList[i];
    var back = max - front;
    diffList.push(Math.abs(front - back));
  }

  return Math.min.apply(null, diffList);
}

```

# References  
- https://codility.com/programmers/task/tape_equilibrium/
