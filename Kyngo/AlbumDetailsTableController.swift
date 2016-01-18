//
//  AlbumDetailsTableController.swift
//  Kyngo
//
//  Created by Vladimir Gnatiuk on 1/18/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke
import MBProgressHUD

class AlbumDetailsTableController: UITableViewController {
    var selectedAlbum: SwiftyJSON.JSON?
    var photos = Array<SwiftyJSON.JSON>()
    var selectedPhoto: SwiftyJSON.JSON?
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        RestAPI.sharedInstance.photos({ (json) -> () in
            if let array = json.array {
                if let selectedId = self.selectedAlbum?["id"].int {
                    self.photos = array.filter({
                        if let albumId = $0["albumId"].int {
                            return selectedId == albumId
                        }
                        return false
                    })
                }
                self.hud?.hide(true)
                self.tableView.reloadData()
            }
            }) { (error) -> () in
                
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "detailsSelected")
        {
            let vc = segue.destinationViewController as! DetailsViewController
            vc.selectedPhoto = selectedPhoto
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AlbumDetailsCell
        cell.titleLabel.text = photos[indexPath.row]["title"].string
        if let urlString = photos[indexPath.row]["thumbnailUrl"].string, let url = NSURL(string: urlString) {
            cell.thumbImage.hnk_setImageFromURL(url)
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPhoto = photos[indexPath.row]
        performSegueWithIdentifier("detailsSelected", sender: self)
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            self.photos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        delete.backgroundColor = UIColor.redColor()
        return [delete]
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

class AlbumDetailsCell: UITableViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}


