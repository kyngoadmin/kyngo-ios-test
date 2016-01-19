//
//  PhotoCell.swift
//  Kyngo
//
//  Created by Alexey Romanko on 19.01.16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit


@objc protocol PhotoCellDelegate
{
    optional func changeTxt(cell: PhotoCell)

}


class PhotoCell: UITableViewCell {

     var delegate: PhotoCellDelegate!
	 weak var indexPath: NSIndexPath!

     @IBOutlet weak var lblText: UILabel!
     @IBOutlet weak var txtText: UITextField!
     @IBOutlet weak var imView:  UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(dict: NSDictionary)
    {
        let str = dict.objectForKey("thumbnailUrl") as! String
        let url = NSURL(string: str)

        imView.sd_setImageWithURL(url)

        let strTitle = dict.objectForKey("title") as! String
        lblText.text = strTitle
        txtText.text = strTitle

        if (editing)
        {
            lblText.hidden = true
            txtText.hidden = false
        }
        else
        {
            lblText.hidden = false
            txtText.hidden = true
        }
        



    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.txtText .endEditing(true)
        self.delegate.changeTxt!(self)
        return false;
    }


    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
