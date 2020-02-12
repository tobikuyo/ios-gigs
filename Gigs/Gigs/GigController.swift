//
//  GigController.swift
//  Gigs
//
//  Created by Tobi Kuyoro on 12/02/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

enum HeaderNames: String {
    case contentType = "Content-Type"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class GigController {
    
    var bearer: Bearer?
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!

    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        let requestURL = baseURL
        .appendingPathComponent("users")
        .appendingPathComponent("signup")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        do {
            request.httpBody = try JSONEncoder().encode(user)
        } catch {
            NSLog("Error encoding user for sign up: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let error = error {
                NSLog("Error signing up: \(error)")
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse,
            response.statusCode != 200 {
                NSLog("Unexpected response")
                completion(NSError())
                return
            }
            
            completion(nil)
        }.resume()
    }
}