//
//  RecordItemView.swift
//  zulzul
//
//  Created by 이희연 on 2/18/25.
//

import SwiftUI

struct RecordItemView: View {
    let title: String
    let category: String
    let memo: String
    let price: Int
    
    var body: some View {
        HStack {
            Image("images/climb-it-mokgam")
                .resizable()
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(Color("RecordTitle"))
                    .bold()
                Text("\(category)ㅣ\(memo)")
                    .font(.system(size: 13))
                    .foregroundColor(Color("RecordDescription"))
            }
            Spacer()
            Text("\(price) 원")
                .font(.system(size: 15))
                .foregroundColor(Color("SpendText"))
                .bold()
        }
    }
}
