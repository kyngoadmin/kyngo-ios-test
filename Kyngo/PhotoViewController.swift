//
//  ViewController.swift
//  Kyngo
//
//  Created by John Sproull on 2016-01-07.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var photo:Photo!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if photo != nil {
            self.title = photo.title
            self.imageView.setImageWithURL(NSURL(string: photo.url)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

