## Intro
Routing.shared 를 이용해 네비게이션 관리

## 1. Without TCA
ContentView.swift 참고
Button 의 action을 통해 네비게이션간의 이동을 합니다.
```
Button("Load View 2-1", action: {
  Router.shared.push(view: ContentViewTwoOne(), animated: true)
})
```

## 2. With TCA
App.swift - Comment out 2 to try TCA version
1. 위에서 했던 방식과 같이 네비게이션간의 이동을 합니다. (TCAContent1, TCAContent2-1, TCAContent3)
2. RouterProtocol 을 Environment로 주입받아서 관리합니다. (TCAContent2)
