//
//  PhotosController.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class PhotosController: UITableViewController {
    
    // MARK: - PhotosController
    
    var library: Library!
    var selectedPhoto: Photo!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PhotoDetail" {
            (segue.destinationViewController as! PhotoDetailController).photo = selectedPhoto
        }
    }
    
    // MARK: - UITableViewController
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return library.photos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as! PhotoCell
        cell.nameLabel?.text = library.photos[indexPath.row].title
        if let thumbnailUrl = NSURL(string: library.photos[indexPath.row].thumbnailUrl) {
            cell.thumbnailImageView.image = nil
            cell.thumbnailImageView.setImageWithURL(thumbnailUrl)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            library.allPhotos = library.allPhotos.filter({ $0.id != library.photos[indexPath.row].id })
            library.updatePhotos()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if editing {
            let photo = library.photos[indexPath.row]
            let alert = UIAlertController(title: nil, message: "Enter new photo title", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = photo.title
            })
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                if let newTitle = alert.textFields?.first?.text where !newTitle.isEmpty {
                    photo.title = newTitle
                    self.tableView.reloadData()
                }
            }))
            presentViewController(alert, animated: true, completion: nil)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            selectedPhoto = library.photos[indexPath.row]
            performSegueWithIdentifier("PhotoDetail", sender: self)
        }
    }
}