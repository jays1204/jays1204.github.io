---
layout: post
title: " find anagram(애너그램 찾기) "
date: 2017-06-20 23:14:26
categories: algorithm, anagram
---

## 애너그램 찾기   
얼마전에 풀어본 알고리즘 문제이다.  
문제는 다음과 같다.  
영어 문자열이 있을때 이 단어의 알파벳들의 위치를 바꾼 새로운 문자열은 원래 문자열의 애너그램이다.  
예를 들어 abef라는 문자열이 있을때 feab는 abef의 애너그램이다.  
문자열 a와 문자열 b가 주어졌을때 b에 속한 일부 문자열은 a의 애너그램이다.  
이때 a의 애너그램이 될 수 있는 b 문자열의 그 일부 문자열의 index를 구하는 것이다. index는 0부터 시작한다.  
주어진 문자열은 ascii코드로 구성된다.  

## 최초 풀이

```javascript
function findAnagram(input, target) {
  var result = [];
  var length = input.length
    , sortedInput = input.split("").sort(function(a, b) {
      return a.localeCompare(b);
    });
  
  for (var i = 0, li = target.length; i < li - length; i++) {
    var substr = target.substr(0, length);
    var sortedSubStr = substr.split("").sort(function(a, b) {
      return a.localeCompare(b);
    });

    if (sortedSubStr == sortedInput) {
      result.push(i);
    }
  }

  return result;
}
```  

최초의 풀이는 위와 같다.  
애너그램은 문자열의 알파벳 구성이 원 단어와 같다는 특징을 이용하였다.  
동일한 알파벳을 가졌으므로 오름차순 정렬을 하여 정렬된 문자열끼리 비교하여 같은 값이면 애너그램인 것이다.  
이를 이용하여 대상 문자열에 대해 0번째 글자부터 대상 문자열 길이 - input문자열 길이까지의 위치까지 루프를 돈다.  
각 이터레이션에서는 주어진 시작 위치부터 input길이로 문자열을 잘라 낸 후 이를 정렬하여 애너그램인지를 비교한다.  
애너그램이면 index를 결과 배열어 넣어준다.  
이를 통해 애너그램 문자열의 시작 위치들을 알아 낼 수 있다.  
다만 이런 해법은 n이 input의 길이, m이 대상 문자열의 길이일때 시간 복잡도가 O(n * (m-n))으로 꽤 복잡도가 크다.  
처음에는 이게 최선의 방법인줄 알았는데 geeksforgeeks.org의 풀이를 보면 더 훌륭한 방법이 나온다.  

## geeksforgeeks에 나온 풀이  
O(n)의 시간 복잡도로 구현을 해낸다.  
여기서 이용한 주된 컨셉은 ASCII코드에 대한 제한 조건이다.  
ASCII코드는 256개의 글자를 가질 수 있다.  이에 대해 두 개의 배열을 이용하여 카운팅을 한다.  
1) 첫번째 count P 배열은 input에 나타나는 글자의 빈도를 저장한다.  
2) 두번째 count TW 배열은 target에서 현재 시점에 비교에 사용할 문자열의 글자 빈도를 저장한다.   

중요한 것은 위의 두개의 count 배열에 대한 비교의 시간 복잡도가 O(1)이라는 것이다. 왜냐하면 256개로 항상 고정되어 있기 때문이다.    


```javascript  
const MAX=256;

function compare(arr1, arr2) {
  for (var i = 0; i < MAX; i++) {
    if (arr1[i] != arr2[i])
      return false;
  }
  return true;
}


function search(input, target) {
  var result = [];
  var M = input.length
    , N = target.length;
  
  //256개의 공간을 갖는 배열을 만들고 모두 0으로 채운다.
  var arrayP = new Array(MAX);
  var arrayTW = new Array(MAX);
  arrayP.fill(0);
  arrayTW.fill(0);

  //P배열에는 input에 있는 아스키코드들에 대해 아스키코드마다 빈도수를 넣어준다. 
  //TW배열은 target의 0번째 부터 input과 길이가 같은 문자열에 대해 마찬가지로 아스키코드 빈도수를 넣어준다.
  for (var i = 0; i < M; i++) {
    arrayP[input[i].charCodeAt(0)]++;
    arrayTW[target[i].charCodeAt(0)]++;
  }

  for (var i = 0; i < N - M; i++) {
    // 주어진 두 배열은 현재 비교할 각 문자열에 대한 아스키 코드 빈도수를 들고 있다. 같은 빈도수 정보를 들고 있는지 비교한다. 빈도수 정보가 같다면 애너그램이다. 
    if (compare(arrayP, arrayTW)) {
      result.push(i);
    }

    // target의 다음에 포함될 글자의 아스키 코드 빈도수 정보를 업데이트 한다. 
    arrayTW[target[i + M].charCodeAt(0)]++;
    // target에 현재 비교에 사용한 글자의 아스키 빈도수 정보를 -1 업데이트 해주어 다음 비교에 글자의 정보가 포함되지 않게 한다.
    arrayTW[target[i].charCodeAt(0)]--;
  }

  // 마지막 차례 글자에 대한 비교를 한다. 비교를 위한 정보 업데이트는 위의 loop에서 이미 끝마쳤다.
  if (compare(arrayP, arrayTW)) {
    result.push(N-M);
  }

  return result;
}

var r = search("ABCD", "BACDGABCDA");
console.log('result', r);

```  

1) 처음 비교를 위해 input과 target의 0번째 부터 input길이까지 문자열 이 두가지에 대해 글자 빈도수 정보를 생성한다.  
2) loop는 0부터 N - M(target길이 - input길이)까지 돌게 된다.  
  - 두개의 빈도수 배열이 같은지 비교하고 같다면 애너그램이다.  
  - 다음 루프에 사용될 target의 i + M 번째 위치의 글자에 대한 빈도수 정보를 TW배열에 업데이트한다.   
  - 현재 루프에 사용된 글자의 정보를 빈도수 정보 배열에 -1을 더하여 정보를 업데이트 한다.  
3) 마지막 위치에 대해서는 아직 체크하지 않았으므로 한번 더 체크한다.  

이로서 O(N)의 시간 복잡도를 갖는 풀이가 완성되었다. 핵심은 아스키 코드라는 특성을 이용해 기존의 O(n)의 과정을 제거한 것이다.  
geeksforgeeks에는 C++로 구현되어있다. 위는 node.js(javascript) 코드이다.


## References  
- http://www.geeksforgeeks.org/anagram-substring-search-search-permutations/  
- https://namu.wiki/w/%EC%95%84%EB%82%98%EA%B7%B8%EB%9E%A8  
