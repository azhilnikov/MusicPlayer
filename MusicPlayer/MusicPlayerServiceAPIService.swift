//
//  MusicPlayerAPIService.swift
//  MusicPlayer
//
//  Created by Alexey on 8/7/17.
//  Copyright © 2017 Alexey Zhilnikov. All rights reserved.
//

import Foundation

class MusicPlayerAPIService {
    
    func fetch(_ name: String, completion: @escaping (Data?, MusicPlayerResult) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        
        let queryItems = [
            URLQueryItem(name: "term", value: name),
            URLQueryItem(name: "country", value: "au"),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "lang", value: "en_au"),
            //URLQueryItem(name: "limit", value: "20")
        ]
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil, .failure("Invalid URL"))
            return
        }
        
        let session = URLSession(configuration: .ephemeral)
        session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(nil, .failure(error.localizedDescription))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .failure("Invalid response"))
                return
            }
            
            if 200 != httpResponse.statusCode {
                completion(nil, .failure("Invalid status code"))
                return
            }
            
            if let data = data {
                completion(data, .success)
            } else {
                completion(nil, .failure("Invalid data"))
            }
        }.resume()
    }
}
