//
//  Address.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import Foundation

class Company: DictionaryConvertible, CustomStringConvertible {
    var name: String!
    var catchPhrase: String!
    var bs: String!
    
    required init?(dictionary: [String: AnyObject]) {
        if let name = dictionary["name"] as? String, catchPhrase = dictionary["catchPhrase"] as? String, bs = dictionary["bs"] as? String {
            self.name = name
            self.catchPhrase = catchPhrase
            self.bs = bs
        } else {
            print("Unexpected company format")
            return nil
        }
    }
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return name
    }
}