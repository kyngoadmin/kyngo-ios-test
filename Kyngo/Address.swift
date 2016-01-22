//
//  Address.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import Foundation

class Address: DictionaryConvertible, CustomStringConvertible {
    var street: String!
    var suite: String!
    var city: String!
    var zipcode: String!
    
    required init?(dictionary: [String: AnyObject]) {
        if let street = dictionary["street"] as? String, suite = dictionary["suite"] as? String, city = dictionary["city"] as? String, zipcode = dictionary["zipcode"] as? String {
            self.street = street
            self.suite = suite
            self.city = city
            self.zipcode = zipcode
        } else {
            print("Unexpected address format")
            return nil
        }
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return "\(suite), \(street), \(city), \(zipcode)"
    }
}