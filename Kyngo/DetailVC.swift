//
//  DetailVC.swift
//  Kyngo
//
//  Created by Alexey Romanko on 19.01.16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imView:  UIImageView!
    @IBOutlet weak var actView:  UIActivityIndicatorView!

    var dictInfo: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		actView.startAnimating()
        reloadData()
    }

    func setData(dict: NSDictionary)
    {
        dictInfo = NSDictionary(dictionary: dict)
        reloadData()
    }

    func reloadData ()
    {
        if (imView != nil)
        {
            let str = dictInfo.objectForKey("url") as! String
            let url = NSURL(string: str)

            imView.sd_setImageWithURL(url, placeholderImage: nil) {
                (UIImage img, NSError err, SDImageCacheType cacheType, NSURL imgUrl) -> Void in
                self.actView.stopAnimating()
                self.actView.hidden = true

            }

            let strTitle = dictInfo.objectForKey("title") as! String
            lblText.text = strTitle
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
