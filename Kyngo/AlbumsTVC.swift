//
//  AlbumsTVC.swift
//  Kyngo
//
//  Created by Alexey Romanko on 19.01.16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class AlbumsTVC: UITableViewController, NetworkDelegate {


    var arrContent: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func loadData()
    {
        let netw = Network()
        netw.delegate = self
        netw.loadAllAlbums()

    }

    // MARK: - NetworkDelegate
    
    func albums(arr:NSArray)
    {
		print(arr)
        arrContent = NSMutableArray(array: arr)
        tableView.reloadData()


    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if ((arrContent) != nil)
        {
	        return arrContent.count
        }
        else
        {
	        return 0
        }

    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AlbumCell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell

        let dict: NSDictionary

        dict = arrContent[indexPath.row] as! NSDictionary
		cell.lblText.text = dict.objectForKey("title") as! String

        return cell
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




    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let photosVC = segue.destinationViewController as! PhotosTVC

		let t = tableView.indexPathForSelectedRow?.row
        let albumId = (arrContent.objectAtIndex(t!) as! NSDictionary).objectForKey("id")?.integerValue
		photosVC.loadDataForAlbumID(albumId!)
    }


}
