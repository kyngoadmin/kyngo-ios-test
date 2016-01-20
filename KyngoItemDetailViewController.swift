//
//  KyngoItemDetailViewController.swift
//  Kyngo
//
//  Created by Abhi on 1/21/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class KyngoItemDetailViewController: UIViewController {

    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var labelTittle: UILabel!
    
    var dict : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTittle.text = dict!.valueForKey("title") as? String
        let strImageURl = dict!.valueForKey("url") as? String
        let data = NSData(contentsOfURL: NSURL(string: strImageURl!)!)
        if data != nil {
            let image = UIImage(data: data!)
            imageViewItem.image = image
        }
        // Do any additional setup after loading the view.
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
