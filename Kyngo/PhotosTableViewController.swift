//
//  PhotosTableViewController.swift
//  Kyngo
//
//  Created by common on 1/14/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class PhotosTableViewController: UITableViewController {

    var dataArray = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        SVProgressHUD.show()
        Photo.getPhotos { (photos, error) -> Void in
            SVProgressHUD.dismiss()
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                if photos == nil {// parse error
                    let alert = UIAlertController(title: "Error", message: "ParseError", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }else{
                    self.dataArray.appendContentsOf(photos)
                    self.tableView.reloadData()
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("photocell", forIndexPath: indexPath)
        
        // Configure the cell...
        if let photo:Photo = dataArray[indexPath.row] {
            cell.textLabel?.text = photo.title
            cell.imageView?.setImageWithURL(NSURL(string: photo.thumbnailUrl)!)
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showdetail" {
            let cell = sender as! UITableViewCell
            var indexPath = self.tableView.indexPathForCell(cell)
            let targetVC = segue.destinationViewController as! PhotoViewController
            targetVC.photo = dataArray[indexPath!.row]
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
