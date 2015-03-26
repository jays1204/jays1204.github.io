---
layout: post
title:  "Android Chrome Intent"
date:   2015-03-26 11:43:22
categories: encoding charset
---

# Android Chrome Intent
  - Android Chrome에서 deep link를 사용
  다른 브라우저들의 경우에는 deep link를 사용하여 앱을 실행시켜주기 위해 보통 다음과 같은 코드를 사용합니다.

  ```
  <script>
    window.location = 'yourapp://deep_link_url';
    window.setTimeout(function() {
      document.location = 'web_site_url'
    }, delay_seconds);
  </script>
  ```

  위의 코드는 브라우저에서 앱을 실행하기 위해 deep link를 실행시키며 만일 반응이 없을 경우 웹페이지로 가게 됩니다.
  
  대부분의 모바일 브라우저에서는 위의 코드로도 무리없이 deep link를 적용하여 앱을 실행할 수 있습니다.
  - 물론 Desktop 브라우저는 당연히 제외하는 것을 가정으로 합니다. -
  현재 위의 코드로 원하는 결과를 낼 수 없는 브라우저가 2가지 있습니다. (물론 이외에도 더 있을 수 있지만 현재 제가
  알고있기로는..) iOS Safari와 Android Chorme입니다. Android Chrome의 경우에는 이전에는 iframe을 통해 앱 설치여부를
  판단하여 앱 실행을 해왔다고 합니다. 하지만 버젼 25이후 부터는 해당 방식을 통한 앱 실행을 지원하지 않는다고 합니다.
  (현재 2015/03/26 기준으로 버젼 41.0.2272.92) 
  따라서 구글의 가이드에 따라 앱 실행 방식을 변경해야 합니다.
  
  구글은 intent anchor를 페이지에 생성하여 사용자가 해당 anchor를 통해 앱을 실행할 수 있게끔 하라고 안내합니다.

  intent anchor는 다음과 같이 작성할 수 있습니다. {{}} 로 감싸진 부분은 선택사항입니다.

  ```
  <a href="intent:{{HOST/URI-path//}}#Intent;scheme=[string];package=[string];{{action=[string]}};{{category=[string]}};{{component=[string]}};end;>text</a>
  ```

  위의 anchor를 생성하기 위해선 앱의 AndroodManifest.xml을 참고해야 합니다.

  - Host
  `<android:host="host_value">`
  - URI-path
    이 부분은 앱에서 intent처리하는 부분을 참고하여 설정해 주시면 됩니다.
  - scheme
  `<android:scheme="schem_value">`
  - pacakge
  `<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.flitto.app">`
  - etc
    나머지는 선택사항으로 자세한 사항은 아래 참고문서를 보시면 됩니다.
  
  위의 anchor를 사용자가 클릭을 통해 앱 설치시에는 앱을 실행시켜 특정 액티비티를 볼 수 있고 앱이 없을시에는 google
  play에 있는 pakcage name과 맞는 앱 설치 페이지로 넘어가게 됩니다.

# 참조
https://developer.chrome.com/multidevice/android/intents
