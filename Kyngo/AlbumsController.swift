//
//  AlbumController.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class AlbumsController: UITableViewController, ApiManagerDelegate {
    
    // MARK: - AlbumsController
    
    let apiManager = ApiManager()
    let library = Library()
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        tableView.setEditing(!tableView.editing, animated: true)
    }
    
    func performDataRequest() {
        apiManager.getAlbums { (albums) -> Void in
            self.library.allAlbums = albums
            self.library.updateAlbums()
            
            self.apiManager.getPhotos({ (photos) -> Void in
                self.library.allPhotos = photos
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationItem.rightBarButtonItem = editButtonItem()
        
        refreshControl = UIRefreshControl()
        refreshControl?.beginRefreshing()
        refreshControl?.addTarget(self, action: "performDataRequest", forControlEvents: .ValueChanged)
        
        apiManager.delegate = self
        performDataRequest()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        library.updateAlbums()
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Photos" {
            (segue.destinationViewController as! PhotosController).library = library
        }
    }
    
    // MARK: - UITableViewController
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return library.albums.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath)
        cell.textLabel?.text = library.albums[indexPath.row].title
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            library.allAlbums = library.allAlbums.filter({ $0.id != library.albums[indexPath.row].id })
            library.updateAlbums()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if editing {
            let album = library.albums[indexPath.row]
            let alert = UIAlertController(title: nil, message: "Enter new album title", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = album.title
            })
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                if let newTitle = alert.textFields?.first?.text where !newTitle.isEmpty {
                    album.title = newTitle
                    self.tableView.reloadData()
                }
            }))
            presentViewController(alert, animated: true, completion: nil)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            library.currentAlbumId = library.albums[indexPath.row].id
            library.updatePhotos()
            performSegueWithIdentifier("Photos", sender: self)
        }
    }
}
