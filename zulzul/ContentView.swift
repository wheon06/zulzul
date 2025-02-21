//
//  ContentView.swift
//  zulzul
//
//  Created by 이희연 on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: NewRecordView()) {
                        Text("추가")
                            .frame(width: 40)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                Divider()
                RecordItemView(
                    title: "클라임잇 목감",
                    category: "클라이밍",
                    memo: "일일 이용권",
                    price: -20000
                )
                RecordItemView(
                    title: "클라임잇 목감",
                    category: "클라이밍",
                    memo: "일일 이용권",
                    price: -20000
                )
                RecordItemView(
                    title: "클라임잇 목감",
                    category: "클라이밍",
                    memo: "일일 이용권",
                    price: -20000
                )
                RecordItemView(
                    title: "클라임잇 목감",
                    category: "클라이밍",
                    memo: "일일 이용권",
                    price: -20000
                )
                RecordItemView(
                    title: "클라임잇 목감",
                    category: "클라이밍",
                    memo: "일일 이용권",
                    price: -20000
                )
                RecordItemView(
                    title: "클라임잇 목감",
                    category: "클라이밍",
                    memo: "일일 이용권",
                    price: -20000
                )
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    ContentView()
}
