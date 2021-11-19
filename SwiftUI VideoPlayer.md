# SwiftUI VideoPlayer

SwiftUI에서는 iOS14 버전에서는, 비디오를 재생할수있는 VideoPlayer로 손쉽게 추가할수있다.
VideoPlayer를 이용하면, 로컬에 저장된 미디어 또는 URL에 등록되어있는 미디어를 재생할수있다.
AVKit을 import하면 사용할수있다.

```swift
// 로컬에 저장되어있는 미디어를 재생하려는 경우
var body: some View {
	VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "video", withExtension: "mp4")!))
}
```

```swift
// url에 등록되어있는 미디어를 재생하려는 경우
var body: some View {
	VideoPlayer(player: AVPlayer(url: URL(string: url)!))
}
```

라이브 스트리밍을 하려는 경우 또한 다르지 않다. 라이브 스트리밍 미디어가 등록된 url을 입력하면 된다.

그 밖에 CustomVideoPlayer를 만들기 위해서는, UIViewControllerRepresentable을 상속하여 만들어야하는데.. 자세한 내용은 해당 링크를 참고하여 예제를 만들었다.
[https://youtu.be/zGe6Dy-JRNI](https://youtu.be/zGe6Dy-JRNI)