//
//  ListPracticeView.swift
//  swiftui-practice
//
//  Created by 이서준 on 2021/09/29.
//

import SwiftUI

// List에 요소로 넣기 위해 Identifiable 프로토콜을 채택한다. 채택하고, 준수하면 key path를 따로 전달 하지 않아도 된다.
struct Track: Identifiable {
    // 고유하게 식별할수있는 id를 구현하여 프로토콜을 준수하고, UUID를 이용하여 매번 객체가 생성될때마다 unique identifier를 만들수있다.
    let id = UUID()
    let title: String
    let artist: String
    let duration: String
    
    let thumbnail = Image(systemName: "heart")
    let gradient: LinearGradient = {
        let colors: [Color] = [.orange, .pink, .purple, .red, .yellow]
        return LinearGradient(gradient: Gradient(colors: [colors.randomElement()!, colors.randomElement()!]), startPoint: .center, endPoint: .topTrailing)
    }()
}

struct Album {
    let tracks: [Track] = [
        Track(title: "none", artist: "Crush", duration: "03:50"),
        Track(title: "NAPPA", artist: "Crush", duration: "03:34"),
        Track(title: "2411", artist: "Crush", duration: "02:30"),
        Track(title: "Hug me", artist: "Crush", duration: "03:30"),
        Track(title: "ohio", artist: "Crush", duration: "02:45"),
    ]
}

struct ListPracticeView: View {
    let data = Album()
    
    var body: some View {
        // List는 각 요소를 고유(uniquely)하게 식별하는 프로퍼티에 대한 키 경로(key path)를 가지는 "identified(by:)" 메소드를 호출한다.
        List(data.tracks) { track in
            TrackRow(track: track)
                // TrackRow를 Container가 아닌 Rectangle이라는 shape로 인식하게 하여, 모든 영역을 tappable하게 만들어줌.
                .contentShape(Rectangle())
                //.background(Color.purple) 오..background됨.. 신기하네
                .onTapGesture {
                    print(track.title)
                }
        }
    }
}

struct TrackRow: View {
    let track: Track
    
    var body: some View {
        HStack {
            track.thumbnail
                .padding()
                .background(track.gradient)
                .cornerRadius(6)
            
            Text(track.title)
            Text(track.artist)
                .foregroundColor(.secondary)
                .lineLimit(1)
                // 텍스트 꼬리쪽 말줄임표
                .truncationMode(.tail)
            
            Spacer()
            
            Text("\(track.duration)")
        }
    }
}
