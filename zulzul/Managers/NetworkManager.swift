//
//  NetworkManager.swift
//  zulzul
//
//  Created by 이희연 on 2/21/25.
//

import Foundation
import KeychainSwift

class NetworkManager: ObservableObject {
    
    let keychain = KeychainSwift()
    
    func makeRequest(urlString: String, method: String, body: Encodable, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        guard let accessToken = keychain.get("access_token") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
            sessionConfig.httpCookieAcceptPolicy = .always
            sessionConfig.httpCookieStorage = HTTPCookieStorage.shared
            sessionConfig.httpShouldSetCookies = true

        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No Response"])))
                return
            }
            
            if let headerFields = httpResponse.allHeaderFields as? [String: String],
                let url = request.url {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                    HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                        
                    for cookie in cookies {
                        print("🍪 쿠키 저장됨: \(cookie.name) = \(cookie.value)")
                    }
                }
            completion(.success((data, httpResponse)))
        }
        task.resume()
    }
}
