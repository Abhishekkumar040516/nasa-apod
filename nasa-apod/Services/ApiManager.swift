//
//  ApiManager.swift
//  Dummy
//
//  Created by Ladoo on 24/04/2022.
//  Copyright © 2022 Ladoo. All rights reserved.
//

import Foundation

struct ApiManager {
    
    func get<T:Decodable>(with url: URL, resultType: T.Type, completion: @escaping(_ result: T?, _ error: String?) -> Void) {
        URLSession.shared.dataTask(with: url){ (responseData, urlResponse, error) in
            if (error == nil &&
                responseData != nil &&
                responseData?.count != 0) {
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: responseData!)
                    _=completion(result,nil)
                } catch let error {
                    debugPrint("API error occured while decoding = \(error.localizedDescription)")
                    _=completion(nil,error.localizedDescription)
                }
            } else {
                _=completion(nil,error?.localizedDescription)
            }
        }.resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
