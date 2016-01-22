//
//  User.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import Foundation

class User: DictionaryConvertible {
    var id: Int!
    var username: String!
    var name: String!
    var email: String!
    var phone: String!
    var website: String!
    var address: Address!
    var company: Company!
    
    required init?(dictionary: [String: AnyObject]) {
        if let id = dictionary["id"] as? Int, name = dictionary["name"] as? String, username = dictionary["username"] as? String, email = dictionary["email"] as? String, phone = dictionary["phone"] as? String, website = dictionary["website"] as? String, addressDictionary = dictionary["address"] as? [String: AnyObject], address = Address(dictionary: addressDictionary), companyDictionary = dictionary["company"] as? [String: AnyObject], company = Company(dictionary: companyDictionary) {
            self.id = id
            self.name = name
            self.username = username
            self.email = email
            self.phone = phone
            self.website = website
            self.address = address
            self.company = company
        } else {
            print("Unexpected user format")
            return nil
        }
    }
}