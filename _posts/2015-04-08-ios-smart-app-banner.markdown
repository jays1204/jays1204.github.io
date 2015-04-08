---
layout: post
title:  "iOS Smart App Banner"
date:   2015-04-08 10:59:00
categories: encoding charset
---

# **iOS Safari Deep link problem**
Mobile Page에서 관련된 App을 실행시켜주거나 App을 설치할 수 있는 페이지로 이동을 도와주는 deep link기능은 safari에서도 제공됩니다.  
iOS Safari에서도 다른 브라우저들과 마찬가지로 location.href 등을 이용하여 구현할 수 있고 App이 설치되어 있는 경우에는 잘동작합니다.  
문제는 App이 설치되어 있지 않은 경우에 발생합니다.

> Safari cannot open the page because the address is invalid

위와 같은 메세지가 담겨있는 alert이 발생하며 이는 썩 좋지 않은 UX를 제공하게 됩니다.  

# **Smart App Banner **
App이 설치되어있지 않은 경우 Safari에서의 Alert을 해결하기 위한 방법으로 iOS에서 공식지원하는 Smart App Banner가 있습니다.  
Smart App Banner는 웹 페이지의 최상단에 위치하게 되며 App store로 가기, 배너 안보이기 등을 제공합니다. 
또한 해당 App이 사용자의 Device에서 지원가능한지 여부를 판별하여 지원불가능한 기기라면 배너를 보여주지 않습니다.  

1. Smart App banner 기능 구현하기  

```
<meta name="apple-itunes-app" content="app-id=myAppStoreID, affiliate-data=myAffiliateData, app-argument=myURL">
```
  - name="apple-itunes-app" : 고정입니다. (필수)
  - app-id=myAppStoreId : app store에 등록한 app의 id입니다.(선택사항)  
      예로 itunes.apple.com/us/app/flitto-kpop-translated-twitter/id493235942 와 같은 app store주소를 갖고 있다면 id는 493235942가 됩니다.
  - affiliate-data=myAppStoreId : affiliate string을 갖고 계시면 입력하면 됩니다. 이 부분은 deep link와는 큰 연관이 없으므로 넘어가겠습니다. (선택사항)
  - app-argument=myURL : 해당 페이지의 deep link url이 됩니다. (선택사항) smart banner의 열기를 누른 경우에 해당 deep link로 이동하게 됩니다.


 Smart App banner 예시 이미지
![Alt text](https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/Art/smartbanner_2x.png)

- 마무리  
딥링크를 구현하면서 느끼는 것은 각 브라우저마다 구현 방법이 다르다는 것입니다. 안드로이드 크롬, iOS Safari, 나머지 브라우저에 대해 분기를 처리해 주고 각 브라우저마다 알맞은 deep link 제공을 해주더라도 UX의 통일성이 지켜지지 않아 아쉬운 점은 있습니다.

# 참조 
- https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/PromotingAppswithAppBanners/PromotingAppswithAppBanners.html
