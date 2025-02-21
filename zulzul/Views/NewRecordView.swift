import SwiftUI
import KeychainSwift

struct NewRecordView: View {
    
    var categoryOptions = ["🛒 쇼핑", "🧗 클라이밍", "🍚 식비"]
    
    let keychain = KeychainSwift()
    
    @StateObject var networkManager = NetworkManager()
    @State private var message = ""
    @State private var responseMessage = ""
    
    @State private var date = Date()
    @State private var title = ""
    @State private var price = ""
    @State private var category = -1
    @State private var memo = ""
    
    // Focus state variables for each text field
    @FocusState private var focusedField: Field?
    
    enum Field {
        case title, price, memo
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            InputWrapper(placeholder: "날짜", content: {
                DatePicker("", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.compact)
            })
            
            InputWrapper(placeholder: "내용", content: {
                TextField("", text: $title)
                    .autocorrectionDisabled(true)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .title)
            })
            
            InputWrapper(placeholder: "금액", content: {
                TextField("", text: $price)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .price)
            })
            
            InputWrapper(placeholder: "카테고리", content: {
                Spacer()
                Picker("", selection: $category) {
                    ForEach(categoryOptions.indices, id: \.self) { index in
                        Text(categoryOptions[index])
                    }
                }
            })
            
            InputWrapper(placeholder: "메모", content: {
                TextField("", text: $memo)
                    .autocorrectionDisabled(true)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .memo)
            })
            
            Divider()
            
            Button(action: saveRecord) {
                Text("저장")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private func saveRecord() {
        if title.isEmpty {
            focusedField = .title
            return
        } else if price.isEmpty {
            focusedField = .price
            return
        } else if memo.isEmpty {
            focusedField = .memo
            return
        }
        
        let newRecordDto = NewRecordDto(
            date: self.date,
            title: self.title,
            price: self.price,
            memo: self.memo
        )
        
        networkManager.makeRequest(
            urlString: "http://localhost:8080/record",
            method: "POST",
            body: newRecordDto
        ) { result in
            switch result {
            case .success(let message):
                responseMessage = "응답: \(message)"
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                responseMessage = "에러: \(error.localizedDescription)"
            }
        }
    }
}

struct InputWrapper<Content: View>: View {
    let placeholder: String
    let content: Content

    init(placeholder: String, @ViewBuilder content: () -> Content) {
        self.placeholder = placeholder
        self.content = content()
    }

    var body: some View {
        HStack {
            Text(placeholder)
                .frame(width: 60, alignment: .leading)
                .foregroundColor(Color("RecordDescription"))
            content
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    NewRecordView()
}
