//
//  DetailsViewController.swift
//  Kyngo
//
//  Created by Vladimir Gnatiuk on 1/18/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fullImageView: UIImageView!
    
    var selectedPhoto: SwiftyJSON.JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let urlString = selectedPhoto?["url"].string, let url = NSURL(string: urlString) {
            fullImageView.hnk_setImageFromURL(url)
        }
        titleLabel.text = selectedPhoto?["title"].string ?? ""
    }

    
}
