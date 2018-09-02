---
layout: post
title: " ad tech tutorial "
date: 2018-09-02 16:04:23
categories: ad-tech DSP SSP ADX publisher advertiser
---

## Ad-tech 간략 소개 
ad-tech에서 일을 갓 시작한 개발자를 위한 간단 안내서이다.   

## 광고의 두 가지 side   
광고를 하기 위해선 우선 최소 2가지 업체가 필요하다.  

  * 광고를 보여줄 수 있는 지면을 가지고 있는 매체사. (이하 publihser)
    * ex) 신문사 웹사이트, 네이버 메인페이지    
  * 광고를 하고 싶어하는 광고주 (이하 advertiser)
    * ex) 삼성전자, 애플  

publisher들은 보통 본인들의 웹사이트를 사용자들이 무료로 이용할 수 있게 제공한다. - 보통은 말이다. -  
이 사이트를 운영하기 위한 서버 관리비, 직원들 월급등은 보통 광고를 사용자에게 보여줌으로서 광고비를 벌어 이익을 벌어들인다.  
돈을 벌기 위한 광고를 실을 곳을 지면(이하 inventory)이라 하고 이곳에 광고를 보여주어 돈을 벌게 된다.  
이를 위해 publisher는 inventory를 공급(supply)한다. 

advertiser는 보통 무언가를 팔고자 하기 위해 사람들에게 홍보를 하고 싶어한다. 이 홍보를 하기 위한 수단중 하나가 바로 광고이다.  
네이버 메인에서 삼성전자의 갤럭시 광고를 보여주거나 페이스북에서 아이패드 광고를 사용자에게 보여주어 제품이 더 많이 팔리기를 원한다.   
이를 위해 advertiser는 inventory를 요구(demand)한다.    


publisher는 inventory에 보여줄 광고를 더 비싸게 팔길 원하고 해당 inventory에 광고가 비어있지 않길 바란다.   
advertiser는 내 제품을 살만한 사람들에게 적절하게 광고를 보여주고 싶어하고 당연히 내 돈이 나갈테니 더 저렴하게 광고를 집행하길 원한다.  

  * '집행'은 광고 노출을 시작한다 정도로 이해하면 된다.  


## 광고의 간략한 흐름  
광고는 보통 다음과 같이 집행된다.  
  
  1. publisher가 inventory를 제공한다.  
  1. advertiser는 본인들의 광고를 집행할 inventory를 찾아 해당 inventory의 publisher와 금액을 협상하고 계약하여 집행하게 된다.   
  1. advertiser는 본인들이 보여줄 광고를 만들어서 해당 정보를 publihser에게 보내준다.  
  1. 이때 inventory에 보여줄 광고의 이미지, 홍보 문구 등을 가리켜서 소재(이하 creative)라고 한다.   
      * 보통 creative를 제작할때에는 inventory의 규격에 맞추어 제작하여 전달한다.  
  1. creative를 받은 publihser는 본인들의 inventory에 해당 광고를 송출한다.  

여기까지 보면 매우 간단하다.  
하지만 세상은 넓고 먹을 걸 탐내는 이해 관계자는 많아지고 살다보면 불편한 것을 편하게 해주려는 tech의 시대에서는 그렇지 않다.  
물론 겉에서 보는 사용자 입장에서야 위의 간략한 흐름과 같다.  
하지만 ad-tech 일을 하는 사람 입장에서는 이제 다음과 같은 복잡한 내부 세상을 알아야 한다.   


## 광고의 조금 복잡한 흐름  
ad-tech에서 일을 시작했다면 DSP, SSP, ad-network, ADX, RTB 등의 용어를 들어봤을 것이다.  
물론 이 용어에 대해 아는 사람이라면 이 글은 전혀~~ 읽을 필요가 없고 들어오지도 않았을 것이다.  
위의 용어들이 어떤 의미인지 왜 생겨나게 되었는지를 광고 흐름에 따라 정리하고자 한다.  
agency, rep사 는 advertiser, publisher와 같은 묶음으로 취급하여 설명한다.  

### ad-network  
살다보니 광고 시장이 폭발했다.  
예전에는 publishser와 advertiser가 직접 계약을 맺으면 되었다.  
하지만 publishser도 늘어나고 advertiser도 늘어나다보니 다음과 같은 문제가 생겼다.   

  * publisher, advertiser가 서로가 서로의 존재를 모르는 경우가 생겨났다.   
  * 각 publisher, advertiser 마다 규격이 달라 서로 연동할때마다 공수가 엄청 커졌다. 
    * oauth 연동을 할때 정해진 규격없이 모든 SNS마다 다 따로 구현한다고 생각해보라! 

이와 같이 여러 publisher, advertiser를 모아서 서로 연결 등을 관리해주는 업체가 생겨났다.  
이러한 역할을 하는 업체군을 ad-network라고 한다.  

ad-netowrk는 마치 부동산 사무소와 같다.  
publisher, advertiser 이 둘 사이를 중개해주고 수수료를 받는다.  
처음에는 모든 기술이 그렇듯이 좋기만 했다.  
연동의 수고도 줄어들고 내가 직접 발로 뛰지 않아도 publisher나 advertiser를 더 알 수 있었다.  
하지만 시간이 지남에 따라 문제가 생기기 시작하였다.   

## ad-exchange  
ad-network를 통해 inventory를 거래하다보면 상황에 따라 inventory가 비워지는 현상이 발생하였다.  

  * 같은 ad-network 안에서만 거래를 하다보니 inventory는 남는데 advertiser가 없는 경우, 
      * 이러면 추가적으로 다른 ad-network에서 advertiser를 가져와야 한다.
  * inventory는 모자라고 advertiser는 넘치는 경우가 발생하였다.  
      * 이러면 추가적으로 다른 ad-network에서 publisher를 가져와야 한다.
  * 여러 ad-network를 사용한다 하더라도 어떤 ad-network에 inventory를 팔거나 사야할지 효율성을 관리할 필요성   

이렇다보니 이전에 publisher, advertiser를 모아 제공하던 ad-network처럼 ad-network를 모아서 제공할 필요가 생겼다.  
이런 ad-network들을 모아 서비스를 제공하는 곳이 바로 ad-exchange다.  
ad-exchange는 여러 ad-network를 모아서 제공하는 것 뿐 아니라 programmatic 광고 방식을 제공한다.  
이전의 ad-network에서 사람 손으로 하던 광고 효율 관리 등의 일을 알아서 해주는 것을 programmatic 광고 방식이라 한다.  
 
  * 예를 들면 더 저렴한 inventory를 찾거나 더 좋은 광고 효과가 나는 inventory를 찾는 등 

이러한 programmatic 방식에는 여러가지가 있는데 대표적인 것이 RTB, 즉 실시간 경매 방식(Real Time Bidding)이다.  
RTB에 대해서는 기회가 된다면 추후 다른 글에서 설명할 예정이다.  

## DSP, SSP   

ad-network와 ad-exchange가 광고주와 매체사를 서로 연결하여 수수료를 취한다면 DSP, SSP는 한쪽 편에 치우진 입장이다.   


### DSP
DSP는 Demande Side Platform으로 광고 이익을 극대화하기 위한 플랫폼으로 Ad-exchange와 연동되어있다.  
DSP는 advertiser 가 가장 효율적으로 광고를 노출하여 목적인 홍보를 달성할 수 있도록 도와준다.   
여기서 효율적인 노출이란 보통 다음을 의미한다.   

  * 많은 사용자에 대한 광고   
  * 저렴한 광고 단가   

DSP는 자체 데이터와 여러 데이터를 이용 Ad-exchange, Ad-network등과 연동하여 가장 저렴한 inventory, 가장 효율적인 inventory 를 알아서 찾아 구매해주는 역할을 한다.  


### SSP  
SSP는 Supply Side Platform으로 inventory에 대한 이익을 극대화하기 위한 플랫폼으로 ad-exchange와 연동되어있다.    
SSP는 publisher를 위해 가장 돈을 많이 벌 수 있도록 도와준다.  
여기서 돈을 많이 벌기 위해서는 보통 다음을 의미한다.  

  * inventory를 비우지 않고 광고 채우기 (fill rate 증가시키기)
  * inventory를 가장 비싼 가격에 판매하기  

SSP는 여러 연동 데이터를 통해 Ad-exchange, Ad-network등과 연동하여 가장 비싸게, 가장 많은 inventory를 파는 역할을 한다.  


## 기타 용어  
Advertiser와 DSP, Ad-exchange, Ad-network 사이, 그리고 Publisher와 SSP, AD-exchange, Ad-network 사이에도 여러 이해 관계가자 존재한다.  

  * agency : 광고주의 대행사다. 광고주를 위해 광고 기획, 소재 제작등을 담당한다.   
  * media rep사 : 이하 렙사 라고 한다. 매체사를 위한 inventory 판매 영업과 inventory 운영 업무를 대행하는 곳 
  * CPM : cost per millle로 1,000회 노출당 가격
  * CPC : cost per click으로 클릭당 가격을 의미
  * CPI : cost per install로 앱 1회 설치당 가격을 의미  


## Caution  
위에서 나온 DSP, SSP, Ad-Exchange, Ad-network가 광고 집행 흐름에 항상 있을거라 생각하면 안된다.  
항상 존재하는건 publihser와 advertiser 뿐이다.  


### References   
  - https://www.slideshare.net/DayeonJeong1/20150419-47165978?ref=http://americanopeople.tistory.com/81?category=604740
  - http://americanopeople.tistory.com/88?category=604740
  - http://pubnative.net/wp-content/uploads/2018/01/Mobile-Ad-Tech-for-Newbies-Vol.1-Demand-Ebook-Korean.pdf
  - http://www.adop.cc/blog/2017/12/15/%EB%94%94%EC%A7%80%ED%84%B8-%EA%B4%91%EA%B3%A0%EC%9D%98-%EA%B7%9C%EC%95%BD-open-rtb-%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0/
  - http://tony-programming.tistory.com/entry/OpenRTB-%EC%9E%85%EC%B0%B0-%EC%9A%94%EC%B2%AD-%ED%8C%8C%ED%8A%B8?category=712131  
  - https://terms.naver.com/entry.nhn?docId=3582200&cid=59088&categoryId=59096#TABLE_OF_CONTENT5
