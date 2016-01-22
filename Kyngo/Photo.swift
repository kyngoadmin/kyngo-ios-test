//
//  Photo.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import Foundation

class Photo: DictionaryConvertible {
    var id: Int!
    var albumId: Int!
    var title: String!
    var url: String!
    var thumbnailUrl: String!
    
    required init?(dictionary: [String: AnyObject]) {
        if let id = dictionary["id"] as? Int, albumId = dictionary["albumId"] as? Int, title = dictionary["title"] as? String, url = dictionary["url"] as? String, thumbnailUrl = dictionary["thumbnailUrl"] as? String {
            self.id = id
            self.albumId = albumId
            self.title = title
            self.url = url
            self.thumbnailUrl = thumbnailUrl
        } else {
            return nil
        }
    }
}
