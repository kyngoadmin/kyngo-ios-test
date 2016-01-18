//
//  RestAPI.swift
//  MusicTest
//
//  Created by Vladimir Gnatiuk on 11/3/15.
//  Copyright © 2015 Vladimir Gnatiuk. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// REST singleton class for communicating with the services
public class RestAPI {
    
    ///  A shared instance of `RestAPI`, used by top-level request methods
    static let sharedInstance = RestAPI()
    
    /// Alamofire manager  that responsible for creating and managing `Request` objects
    private let manager = Alamofire.Manager()
    
    /**
     Get Albums
     */
    public func albums(success:(JSON) -> (), failure: (error: NSError?) -> ()) {
        let router = Router.Albums
        manager.request(router).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    success(json)
                }
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
    
    /**
     Get photos
     */
    public func photos(success:(JSON) -> (), failure: (error: NSError?) -> ()) {
        let router = Router.Photos
        manager.request(router).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    success(json)
                }
            case .Failure(let error):
                failure(error: error)
            }
        }
    }
}


/// Router helps to manage requests to specific target
enum Router: URLRequestConvertible {
    
    /// Base url
    static let baseURLString = "http://jsonplaceholder.typicode.com"
    
    /// Target list
    case Albums
    case Photos
    
    /// HTTP method for specific target
    var method: Alamofire.Method {
        switch self {
        case .Albums:
            return .GET
        case .Photos:
            return .GET
        }
        
    }
    
    /// Path for specific target for base URL
    var path: String {
        switch self {
        case .Albums:
            return "/Albums"
        case .Photos:
            return "/Photos"
        }
    }
    
    /// Parameters for specific target
    var params: Dictionary<String, AnyObject> {
        switch self {
        default:
            return Dictionary<String, AnyObject>()
        }
    }
    
    // MARK: URLRequestConvertible
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: params).0
    }
}