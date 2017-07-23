---
layout: post
title: " Parallel(병렬) vs Concurrency(동시) "
date: 2017-07-16 14:53:07
categories: paralle, concurrency
---

## Parallel vs Concurrency  
Parallel(병렬)과 Concurrency(동시)의 개념에 대해 질문을 받았는데 이에 알지 못해 이번에 공부하여 정리한다.  
여태까지는 위 두 단어를 동일한 의미로 사용을 해왔는데 이게 반은 맞고? 반은 틀렸었다.  
동일 task를 Parallel로 구현하거나 Concurrency로 구현했을때 밖에서 바라보면 둘 다 여러개를 동시에 처리하는 것처럼 보이기에 반은 맞다고 말하였다.  
하지만 내부는 다르다.  

Parallel, Concurrency 둘다 하나의 task에 대해 여러 일꾼(multi thread)가 돌아가는 것은 같다.  
하지만 내부적으로 Parallel은 이 task에 대해 여러 thread가 동시간대에 진행 될 수 있다.  
즉 특정 시각에 N개의 thread가 heap의 특정 변수에 접근이 가능하다는 것이다.  
이러한 이유로 흔히 우리가 멀티쓰레드 프로그래밍을 할 때 resource에 대한 lock/unlock을 잘해야 한다는 말을 한다.  
Concurrency는 task에 대해 여러 thread를 진행하게 할 수 있다. 다만 특정 시간에 수행되는 thread는 하나이다.  
다른 thread들은 잠시 대기한다.  이렇게 하면 그냥 멍청하게 락 걸어서 대기하는 싱글 쓰레드 같다.  
하지만 task에 대해 상세하게 독립적인 단위로 쪼깨어보자.  
task는 A, B, C, D, E의 단계로 나뉘어져 있고 쓰레드는 2개가 있다고 가정해 보자.  
쓰레드 1은 A, B에 대해 처리를 하고 잠시 대기 상태 후 C, D, E처리로 넘어갈 것이다. 이때 쉬는 시간에 쓰레드 2가 A, B를 처리하게 된다.  쉬고 있는 자원을 활용한다고 생각하면 된다.  
더 간단한 이해는 node.js의 처리 방식이다.  Node.js는 흔히 싱글 쓰레드로 돌아간다고 알려져 있다.  
이때 싱글 쓰레드는 코드의 로직을 실행하는 쓰레드이다.  이 쓰레드가 어떤 일을 실행할지 순서와 일을 담아두는 event loop가 있어 이를 관리하여 일을 처리하게 한다.  

내가 이해한 바를 가장 간단히 정의하면 다음과 같다.  
병렬과 동시성 모두 밖에서 보기엔 여러개가 동시에 일을 수행한다.  차이점은 병렬은 내부에서도 동시에 여러개를 수행, 동시성은 매우 짧은 시간 동안 실행 쓰레드가 왔다 갔다 하면서 자원에 대한 간섭없이 일을 처리한다는 것이다.  

더 자세한 것은 아래 출처를 보면 이해가 쉬울 것이다.  


# References  
- https://bytearcher.com/articles/parallel-vs-concurrent/   
- https://www.google.co.kr/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&ved=0ahUKEwjGsaL3jY3VAhVFxLwKHa7iD3IQFggrMAE&url=http%3A%2F%2Frapapa.net%2F%3Fp%3D2704&usg=AFQjCNFAW8R4Zz4y8NKzf4jpfHec7gkZxQ&cad=rjt  
