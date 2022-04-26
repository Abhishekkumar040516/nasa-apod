//
//  APIResource.swift
//  Dummy
//
//  Created by Ladoo on 24/04/2022.
//  Copyright © 2022 Ladoo. All rights reserved.
//

import Foundation

struct APIResource {
    
    /// Get API resource from api.plist else stop execution (crash)
    ///
    /// -   Parameters:
    ///     - No Params required
    /// - Returns:
    ///     [String: [String: String]]?
            
    static func get() -> [String: [String: String]]? {
        var resource: [String: [String: String]]?
        
        if let apiPlist = Bundle.main.url(forResource: "api", withExtension: "plist") {
            do {
                let apiData = try Data(contentsOf: apiPlist)
                if let plistResource = try PropertyListSerialization.propertyList(from: apiData,
                                                                             options: [],
                                                                             format: nil) as? [String: [String: String]] {
                    resource = plistResource
                }
            } catch {
                fatalError("Something went wrong, while preparing api resource")
            }
        }
        
        return resource
    }
}
