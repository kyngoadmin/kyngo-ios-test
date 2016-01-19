//
//  Network.swift
//  Kyngo
//
//  Created by Alexey Romanko on 19.01.16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

enum REQ_TYPE : String {
    case  ALBUMS , PHOTOS
}

@objc protocol NetworkDelegate
{
    optional  func albums(arr:NSArray)
    optional  func photos(arr:NSArray)
}

class Network: NSObject,NSURLSessionDelegate {

    var delegate: NetworkDelegate!


    func loadAllAlbums()
    {
		sendReqWithMethod(.ALBUMS, dict: nil)
    }

    func loadPhotosForAlbum(albumId: NSInteger)
    {
        let dict = NSMutableDictionary()
        dict.setObject(NSString(format: "%d", albumId), forKey: "albumId")
        sendReqWithMethod(.PHOTOS, dict: dict)
    }

    //-------------------------------------------------------------------------------------------------
    // MARK: - sendReqWithMethod
    private func sendReqWithMethod(req_type: REQ_TYPE, dict:NSMutableDictionary!)
    {
        var urlString = "http://jsonplaceholder.typicode.com/"
        var paramString : NSString = ""

        switch req_type
        {
        case .ALBUMS: 		urlString = urlString+"albums"; break
        case .PHOTOS:
            urlString = urlString+"photos";
                for (key, value) in dict
                {
                    var symbol="?"
					if (paramString.length > 0)
                    {
                        symbol="&"
                    }

                    paramString = paramString.stringByAppendingFormat("%@%@=%@",symbol, key as! NSString, value as! NSString)

		        }
            urlString = urlString.stringByAppendingString(paramString as String)
            break

        }


        let url:NSURL = NSURL(string: urlString)!


        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"

        if (paramString.length>0)
        {
         //   request.HTTPMethod = "POST"
        //        let data = (paramString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        //        request.HTTPBody = data
        }


        let config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let queue = NSOperationQueue.mainQueue()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: queue)
        session.sessionDescription = req_type.rawValue

        print("------------------\nrequset \(req_type) with url \(url)")
        print("params \(dict)")


        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if (error == nil)
            {
                var status: NSInteger
                let resp:NSHTTPURLResponse = response as! NSHTTPURLResponse
                status = resp.statusCode
                if (status >= 400)
                {
                     print("status \(status)")
                }
                else
                {
                    self.parseAnswer(data!, req_type: req_type)
                }


            }
            else
            {
                print("urlsession error \(error)")
            }

        }

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        task.resume()

    }

    //-------------------------------------------------------------------------------------------------
    private func parseAnswer(dataAnswer:NSData, req_type:REQ_TYPE)
    {
        print("------------------\nanswer for \(req_type)")
        let dataString = NSString(data: dataAnswer, encoding: NSUTF8StringEncoding)!
        print(dataString)

        let decodedObject: AnyObject
        do {
            decodedObject = try NSJSONSerialization.JSONObjectWithData(dataAnswer, options: [])

        } catch let error as NSError {
            decodedObject = ""
            print(error)
        }
        print(decodedObject)

        switch req_type
        {
        case REQ_TYPE.ALBUMS:

            self.delegate.albums!(decodedObject as! NSArray)

            break;
        case REQ_TYPE.PHOTOS:
             self.delegate.photos!(decodedObject as! NSArray)
            print(req_type)
            break;

        }
    }


}
