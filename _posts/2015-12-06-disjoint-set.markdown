---
layout: post
title: " disjoint set "
date: 2015-12-06 23:34:24
categories: algorithm ds
---

# Disjoint set
분리 집합. 교집합을 갖지 않는 집합으로 결합 연산을 효율적으로 할 수 있게 해준다.  
주요 연산으로는 find(찾기), union(합치기)가 있다.   
disjoint set의 root는 set의 정보를 갖게된다.  
root는 보통 아무렇게 정한다.

## find
disjoint set에 대해 element가 속한 subset을 찾는 연산을 의미한다.
  - root를 계속해서 찾아나가면 root가 subset을 가리키고 있다.

## union
두 개의 disjoint set을 합하는 연산을 의미한다. 
  - A, B 둘 중 root가 될 것을 정한다. 
  - A가 root라면 B의 root element를 A의 root element로 set한다.
