---
layout: post
title: " Python sort algorithm "
date: 2015-11-22 22:28:04
categories: {{python}}
---

# Python Sort Algorithm
파이썬 알고리즘 공부를 하면서 가장 첫장에 나오는 부분은 대학시절 자료구조 시간에 배운 기본적인 정렬 알고리즘들이다. 


- Insertion Sort  
한국말로는 삽입 정렬이다. 이 알고리즘는 다음과 같이 동작한다.
  - n개의 정렬 가능한 원소를 가진 리스트가 있다.
  - i=0(시작점) 부터 시작하여 바로 이미 이전에 정렬된 목록의 요소들과 비교하여 알맞은 자리에 추가한다.
  - 이를 i=n까지 반복하면 정렬이 끝난다.
  - O(n^2)의 복잡도를 갖는다.
   
```python
def insertion_sort(A):
  for i in xrange(1, len(A)):
    for j in xrange(i, 0, -1):
      if A[j] < A[j - 1]:
        A[j -1], A[j] = A[j], A[j-1]
      else:
        break
```

- Merge Sort  
대표적인 분할 정복(divide and conquer)의 기법이다.  
  - 목록의 길이가 0 또는 1이면 해당 목록은 정렬된 목록이다.
  - 정렬되지 않은 목록을 2개로 분할 한 후 이를 다시 비슷한 크기의 2개의 목록으로 만든다. 
  - 이 목록에 대해 재귀적으로 merge sort를 하여 정렬을 한다.
  - 정렬 된 두개의 부분 목록을 합병한다.
  - O(nlogn)

```python
def merge_sort(A):
  if len(A) <= 1:
    return A

  l = len(A)
  k = l // 2

  m = mege_sort(A[:k])
  n = merge_sort(A[k:])

  result = []
  
  i, j = 0, 0
  while i < len(m) and j < len(n):
    if m[i] < n[j]:
      result.append(m[i])
      i = i+1
    else:
      result.append(n[j])
      j = j+1

  result += m[i:]
  result += n[j:]
  return result

```

- Dynamic programming, Greedy Algorthim
동적 프로그래밍을 통해 반복 연산을 줄일 수 있다.  
동적 프로그래밍이란 문제를 작게 나누어서 이미 계산된 결과에 대해서는 값을 유지하며 이를 이용하여 더 큰 문제를 풀어나가는 방법을 말한다.  
위의 합병 정렬에도 dynamic programming을 이용할 수 있다.  
Greedy Algorthim은 동적 프로그래밍보다 더 빠르게 문제를 해결을 할 수 있다. 다만 그 해법이 항상 최적임을 보장하지는 않는다.   
greedy는 동적과 마찬가지로 문제를 작은 단위로 나누어 풀되 이때 가장 최적으로 보이는 해법을 바로 선택하는 것이다.   
작은 단위에서의 최적 해법이 전체에서의 최적을 보장하지는 않는다.
ex) 네비게이션의 구간별 최적 구간의 합이 항상 전체의 최적은 아니다.

```python
def memoize(func):
  memo = {}
  def helper(x):
    if x not in memo:
      memo[x] = func(x)
    return memo[x]

  return helper
```

- Quick Sort  
퀵소트는 가장 빠른 정렬이다. 
  - 정렬 가능한 목록이 있다고 할대 목록을 임의 값 p(pivot)를 기준으로 두개로 나눈다. 이때 p에 따라 정렬 시간에 차이가 있을 수 있다.  
  - 목록은 p에 의해 나뉘는데 이때 p보다 앞선 곳에는 p보다 작은 값들을, 뒤에는 더 큰 값이 오도록 목록을 나눈다. 이 분할을 재귀적으로 실행한다.
  - 목록의 길이가 1보다 작거나 같으면 정렬된 것으로 본다.
  - O(nlogn) 

- Counting Sort  
계수 정렬이라고 한다. 이는 0이상의 정수에 대해 사용가능하다.
  - 목록에 대해 각 요소로 몇번이 있는지 세어 이를 목록에 각 요소를 인덱스로 하여 저장한다.
  - 계수 목록이 C이며 index는 i, 기존의 정렬되지 않은 목록은 K, index는 j라고 하면 다음과 같이 진행된다.
  - K[C[i]] = i가 들어가며 C[i]는 -1이 더해진다. 
  - 이를 C의 목록을 돌며 C[i]가 모두 0이 될때까지 진행하면 정렬된 목록이 나타난다.
  - O(n)
