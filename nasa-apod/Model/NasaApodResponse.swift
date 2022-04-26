//
//  NasaApodResponse.swift
//  Dummy
//
//  Created by Ladoo on 24/04/2022.
//  Copyright © 2022 Ladoo. All rights reserved.
//

import Foundation

struct NasaApodResponse: Codable {
    var date: String
    var explanation: String
    var hdurl: String
    var media_type: String
    var service_version: String
    var title: String
    var url: String
    
    init(date: String,
         explanation: String,
         hdurl: String,
         media_type: String,
         service_version: String,
         title: String,
         url: String) {
        
        self.date = date
        self.explanation = explanation
        self.hdurl = hdurl
        self.media_type = media_type
        self.service_version = service_version
        self.title = title
        self.url = url
    }
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
        guard let label = label else { return nil }
        return (label, value)
      }).compactMap { $0 })
      return dict
    }
}
