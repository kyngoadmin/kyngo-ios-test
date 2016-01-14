//
//  Photo.swift
//  Kyngo
//
//  Created by common on 1/14/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class Photo: NSObject {
    var albumId:Int!
    var photoId:Int!
    var title:String!
    var url:String!
    var thumbnailUrl:String!
    internal convenience init(dictionary:Dictionary<String, AnyObject>){
        self.init()
        self.albumId        = (dictionary["albumId"]?.integerValue)!
        self.photoId        = (dictionary["id"]?.integerValue)!
        self.title          = dictionary["title"] as! String
        self.url            = dictionary["url"] as! String
        self.thumbnailUrl   = dictionary["thumbnailUrl"] as! String
    }
    
    class func getPhotos(responseHandle:(photos:[Photo]!, error:NSError!)->Void) -> Void {
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: "http://jsonplaceholder.typicode.com/"))
        
        manager.GET("photos", parameters: nil, progress: { (progress) -> Void in
            
            }, success: { (dataTask, resObject) -> Void in
                var photos = [Photo]()
                if let resArray = resObject as? NSArray {
                    for dictionary in resArray {
                        let album = Photo(dictionary: dictionary as! Dictionary<String, AnyObject>)
                        photos.append(album)
                    }
                    responseHandle(photos: photos, error: nil)
                }else{
                    responseHandle(photos: nil, error: nil)
                }
                
            }) { (dataTask, error) -> Void in
                responseHandle(photos: nil, error: error)
        }
    }
}
