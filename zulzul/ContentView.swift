//
//  ContentView.swift
//  zulzul
//
//  Created by 이희연 on 2/18/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
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
    }
}

#Preview {
    ContentView()
}
