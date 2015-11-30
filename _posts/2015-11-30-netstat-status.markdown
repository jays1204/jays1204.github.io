---
layout: post
title: " netstat status "
date: 2015-11-30 10:42:46
categories: {{linux}}
---

# netstat
machine의 네트워크 상태, 라우팅 테이블 등의 정보를 보여준다. 해당 커맨드에는 여러가지 옵션이 있다. linux기준이다.

  - a  
  --all의 약자이다. listeninig, non-listening port 모두 보여주도록 한다. 

  - n  
ip address와 port를 숫자로 표시한다. 보통 ssh와 같은 정해진 port는 ssh로 표시되는데 이를 22로 표시한다.

  - p  
--program의 약자이다. 각 소켓이 속한 프로그램의 이름과 PID를 보여준다.

  - t   
tcp protocol만 보여준다.
  - u  
udp protocol만 보여준다.



## netstat -anp
아래와 같이 보여질 것이다.  

```bash
socket_type 0 0 source_ip desction_ip state PID/program_name
```
