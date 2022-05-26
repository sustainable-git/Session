# Accessibility

<div align="center">
<img src="https://developer.apple.com/assets/elements/icons/accessibility/accessibility-128x128.png">
</div>

- Approximately **one in seven people worldwide** have a disability that affects the way they interact with the world and their devices.

<br>

## Accessibility, not just for people with disabilities

<img src="https://cf.festa.io/img/2021-3-19/ce5be971-b96c-457c-a40a-2643c0c47d06.png">

<br>

## Applicable Laws and Guidelines 

- [「장애인차별금지 및 권리구제 등에 관한 법률」](http://www.kwacc.or.kr/Accessibility/Law)
- [모바일 애플리케이션 콘텐츠 접근성 지침 2.0](http://www.kwacc.or.kr/Board/DataFile/668/Detail?page=1)
- [NULI](https://nuli.navercorp.com/guideline/s03/g17)

<br>

## Examples

- Color-independent Perception
    - <img src="https://miro.medium.com/max/1310/1*OxdDXiWKi65lnB13vZG5Bg.jpeg">

- Brightness/Contrast
    - It is easy to read when the contrast between the text and the background color is **4.5 : 1** or higher
    - <img src="https://inswave.com/confluence/download/attachments/20121271/04.png?version=1&modificationDate=1637202201000&api=v2">

<br>

## Voice Over

- Voice Over
    - [VoiceOver: App Testing Beyond The Visuals](https://developer.apple.com/videos/play/wwdc2018/226/)
    - A Screen reader, for the visually impaired
    - Alternative way of using apps
    
- How to turn on Voice Over
    - 1. Settings(설정 앱)
    - 2. Accessibility(손쉬운 사용)
    - 3. Accessiblity shortcut(손쉬운 사용 단축키)
    - 4. Voice Over
    - Now, you can turn on/off, triple clicking side button

- Navigating with Voice Over
    - Touch Navigation
    - Flick Navigation
    - Pause VoiceOver Speach
        - Two finger touch
    - Activating a Button
        - Double tab
    - Go Home
        - Short Drag from bottom : Home
        - Long Drag from bottom : App Switcher
        - Short Drag from top : Control Center
        - Long Drag from bottom : Notification Center
    - Scrolling
        - Three finger Flick
    - Closing
        - Two finger scrub
    - Change Options Using Rotor
        - Two finger turning around center point
        - To adjust value, flick up and down

- Screen curtain
    - Three finger tap three times

<br>

## Demo

```swift
//
//  ContentView.swift
//  SwiftUITutorial
//
//  Created by Shin Jae Ung on 2022/04/01.
//

import SwiftUI

struct ContentView: View {
    @State private var isOn1: Bool = true
    @State private var isOn2: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    CellView()
                    AccessibilityCellView()
                        .accessibilityElement(children: .contain)
                }
                SettingToggle(isOn: self.$isOn2)
                AccessibilitySettingToggle(isOn: self.$isOn1)
            }
            .navigationTitle("Example")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CellView: View {
    var body: some View {
        VStack {
            Text("🚫")
            Image(systemName: "photo.artframe")
            Text("그림 이름")
                .font(.system(size: 17))
            Text("그림 설명")
                .font(.system(size: 16))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke()
        )
    }
}

struct AccessibilityCellView: View {
    var body: some View {
        VStack {
            Text("✅")
                .accessibilityHidden(true)
            Image(systemName: "photo.artframe")
                .accessibilityLabel("그림 대체 텍스트")
                .accessibilitySortPriority(0)
            Text("그림 이름")
                .font(.body)
                .accessibilitySortPriority(2)
            Text("그림 설명")
                .font(.callout)
                .accessibilitySortPriority(1)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke()
        )
    }
}

struct SettingToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle("Wi-Fi", isOn: self.$isOn)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke()
            )
            .padding()
    }
}

struct AccessibilitySettingToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle("Wi-Fi", isOn: self.$isOn)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke()
            )
            .padding()
            .accessibilityValue(self.isOn ? "켜짐" : "꺼짐")
            .accessibilityHint("설정을 변경하려면 이중 탭 하십시오")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        ContentView()
            .environment(\.dynamicTypeSize, .accessibility2)
    }
}
```

<br>

## References
- [개발자와 사용자 모두를 위한 접근성](https://festa.io/events/1468)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/accessibility/overview/introduction/)
- [색에 무관한 콘텐츠 인식](https://medium.com/@dochoul/색에-무관한-콘텐츠-인식-404932558217)
- [명도 대비](https://inswave.com/confluence/pages/viewpage.action?pageId=20121271)
