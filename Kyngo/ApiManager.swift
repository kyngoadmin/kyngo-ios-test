//
//  ApiManager.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import Foundation

enum ApiMethod: String {
    case Albums = "albums"
    case Photos = "photos"
    case Users = "users"
}

protocol ApiManagerDelegate {
    func apiManager(manager: ApiManager, didCompleteMethod method: ApiMethod, withErrorMessage message: String)
}

extension ApiManagerDelegate where Self: UIViewController {
    func apiManager(manager: ApiManager, didCompleteMethod method: ApiMethod, withErrorMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

class ApiManager {
    
    let baseUrlString = "http://jsonplaceholder.typicode.com/"
    var sessionManager: AFHTTPSessionManager
    var delegate: ApiManagerDelegate?
    
    init() {
        let baseUrl = NSURL(string: baseUrlString)!
        sessionManager = AFHTTPSessionManager(baseURL: baseUrl)
    }
    
    private func dataRequestWithMethod(method: ApiMethod, completionHandler: ([[String: AnyObject]]) -> Void) {
        sessionManager.GET(method.rawValue, parameters: nil, progress: nil, success: { (task, json) -> Void in
            if let dictionaryArray = json as? [[String: AnyObject]] {
                completionHandler(dictionaryArray)
            } else {
                self.delegate?.apiManager(self, didCompleteMethod: method, withErrorMessage: "Unexpected data format")
            }
        }, failure: { (task, error) -> Void in
            self.delegate?.apiManager(self, didCompleteMethod: method, withErrorMessage: "Communication error: \(error.localizedDescription)")
        })
    }
    
    private func convertDictionaryArray<T: DictionaryConvertible>(dictionaryArray: [[String: AnyObject]], ofType: T.Type) -> [T] {
        var objects = [T]()
        for dictionary in dictionaryArray {
            if let object = T(dictionary: dictionary) {
                objects.append(object)
            }
        }
        return objects
    }
    
    func getAlbums(completionHandler: ([Album]) -> Void) {
        dataRequestWithMethod(.Albums) { (dictionaryArray) -> Void in
            let objects = self.convertDictionaryArray(dictionaryArray, ofType: Album.self)
            completionHandler(objects)
        }
    }
    
    func getPhotos(completionHandler: ([Photo]) -> Void) {
        dataRequestWithMethod(.Photos) { (dictionaryArray) -> Void in
            let objects = self.convertDictionaryArray(dictionaryArray, ofType: Photo.self)
            completionHandler(objects)
        }
    }
    
    func getUsers(completionHandler: ([User]) -> Void) {
        dataRequestWithMethod(.Users) { (dictionaryArray) -> Void in
            let objects = self.convertDictionaryArray(dictionaryArray, ofType: User.self)
            completionHandler(objects)
        }
    }
    
}