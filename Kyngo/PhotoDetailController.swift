//
//  PhotoDetailController.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class PhotoDetailController: UIViewController {
    
    // MARK: - PhotoDetailController
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = photo.title
        if let url = NSURL(string: photo.url) {
            imageView.setImageWithURL(url)
        }
    }
    
}
