//
//  AlbumCell.swift
//  Kyngo
//
//  Created by Alexey Romanko on 19.01.16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

@objc protocol AlbumCellDelegate
{
    optional func changeTxt(cell: AlbumCell)

}


class AlbumCell: UITableViewCell {

    var delegate: AlbumCellDelegate!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var txtText: UITextField!
    weak var indexPath: NSIndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.txtText .endEditing(true)
        self.delegate.changeTxt!(self)
        return false;
    }


}
