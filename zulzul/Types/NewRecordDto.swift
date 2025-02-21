//
//  NewRecordDto.swift
//  zulzul
//
//  Created by 이희연 on 2/21/25.
//

import SwiftUI

struct NewRecordDto: Codable {
    var date: String
    var title: String
    var category: String
    var price: Int
    var memo: String
    
    init(date: Date, title: String, price: String, category: String = "기타", memo: String) {
        let formatter = ISO8601DateFormatter()
        self.date = formatter.string(from: date) // Date를 String으로 변환
        self.title = title
        self.price = Int(price) ?? 0 // 가격을 숫자로 변환 (문자열에서 Int로 변환)
        self.category = category
        self.memo = memo
    }
}
