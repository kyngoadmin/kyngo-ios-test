//
//  Album.swift
//  Kyngo
//
//  Created by common on 1/14/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class Album: NSObject {
    var userId:Int!
    var albumId:Int!
    var title:String!
    internal convenience init(dictionary:Dictionary<String, AnyObject>){
        self.init()
        self.userId     = (dictionary["userId"]?.integerValue)!
        self.albumId    = (dictionary["id"]?.integerValue)!
        self.title  = dictionary["title"] as! String
    }
    
    class func getAlbums(responseHandle:(albums:[Album]!, error:NSError!)->Void) -> Void {
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: "http://jsonplaceholder.typicode.com/"))
        
        manager.GET("albums", parameters: nil, progress: { (progress) -> Void in
            
            }, success: { (dataTask, resObject) -> Void in
                var albums = [Album]()
                if let resArray = resObject as? NSArray {
                    for dictionary in resArray {
                        let album = Album(dictionary: dictionary as! Dictionary<String, AnyObject>)
                        albums.append(album)
                    }
                    responseHandle(albums: albums, error: nil)
                }else{
                    responseHandle(albums: nil, error: nil)
                }
                
            }) { (dataTask, error) -> Void in
                responseHandle(albums: nil, error: error)
        }
    }    
}
