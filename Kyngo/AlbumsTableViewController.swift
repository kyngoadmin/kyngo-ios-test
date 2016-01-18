//
//  AlbumsTableViewController.swift
//  Kyngo
//
//  Created by Vladimir Gnatiuk on 1/18/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit
import SwiftyJSON

class AlbumsTableViewController: UITableViewController {

    var selectedAlbum: JSON?
    var albums = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        RestAPI.sharedInstance.albums({ (json) -> () in
            if let array = json.array {
                self.albums = array
                self.tableView.reloadData()
            }
        }) { (error) -> () in
                
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "selectedAlbum")
        {
            let vc = segue.destinationViewController as! AlbumDetailsTableController
            vc.selectedAlbum = selectedAlbum
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel!.text = albums[indexPath.row]["title"].string
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedAlbum = albums[indexPath.row]
        performSegueWithIdentifier("selectedAlbum", sender: self)
    }
}

