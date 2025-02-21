//
//  LoginView.swift
//  zulzul
//
//  Created by 이희연 on 2/21/25.
//

import SwiftUI
import KeychainSwift

struct LoginView: View {
    
    let keychain = KeychainSwift()
    
    @StateObject var networkManager = NetworkManager()
    @State private var message = ""
    @State private var responseMessage = ""
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("아이디를 입력해주세요", text: $username)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            TextField("비밀번호를 입력해주세요", text: $password)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            Divider()
            Button(action: handleClickLogin) {
                Text("로그인")
            }
        }
        .padding()
    }
    
    private func handleClickLogin() {
        let registerDto = RegisterDto(
            username: self.username,
            password: self.password
        )

        networkManager.makeRequest(
            urlString: "http://localhost:8080/auth/login",
            method: "POST",
            body: registerDto
        ) { result in
            switch result {
            case .success(let (_, response)):
                if let setCookieHeader = response.allHeaderFields["Set-Cookie"] as? String {
                    let cookieArray = setCookieHeader.components(separatedBy: "; ")
                    var accessToken: String?
                    var refreshToken: String?

                    for cookie in cookieArray {
                        print("Cookie: \(cookie)")
                        if let accessRange = cookie.range(of: "accessToken=") {
                            accessToken = String(cookie[accessRange.upperBound...])
                        } else if let refreshRange = cookie.range(of: "refreshToken=") {
                            refreshToken = String(cookie[refreshRange.upperBound...])
                        }
                    }
                    
                    if let accessToken = accessToken, let refreshToken = refreshToken {
                        saveToken(accessToken: accessToken, refreshToken: refreshToken)
                        print("Tokens saved!")
                    } else {
                        print("Failed to extract tokens")
                    }
                } else {
                    print("No Set-Cookie header found")
                }

            case .failure(let error):
                print("에러: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveToken(accessToken: String, refreshToken: String) {
        keychain.set(accessToken, forKey: "access_token")
        keychain.set(refreshToken, forKey: "refresh_token")
    }
    
    func getAccessToken() -> String? {
        return keychain.get("access_token")
    }

    func getRefreshToken() -> String? {
        return keychain.get("refresh_token")
    }

    func deleteTokens() {
        keychain.delete("access_token")
        keychain.delete("refresh_token")
    }
}

#Preview {
    LoginView()
}
