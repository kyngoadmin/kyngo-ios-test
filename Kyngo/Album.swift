//
//  Album.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import Foundation

class Album: DictionaryConvertible {
    var id: Int!
    var userId: Int!
    var title: String!
    
    required init?(dictionary: [String: AnyObject]) {
        if let id = dictionary["id"] as? Int, userId = dictionary["userId"] as? Int, title = dictionary["title"] as? String {
            self.id = id
            self.userId = userId
            self.title = title
        } else {
            print("Unexpected album format")
            return nil
        }
    }
}
