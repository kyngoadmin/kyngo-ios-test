//
//  AlbumsTVC.swift
//  Kyngo
//
//  Created by Alexey Romanko on 19.01.16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class AlbumsTVC: UITableViewController, NetworkDelegate, AlbumCellDelegate {


    var arrContent: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()


        self.navigationItem.rightBarButtonItem = self.editButtonItem()

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


    func changeTxt(cell: AlbumCell)
    {
        let dcit: NSMutableDictionary = NSMutableDictionary(dictionary: arrContent.objectAtIndex(cell.indexPath.row) as! [NSObject : AnyObject])
        let i = arrContent.indexOfObject(dcit)
        dcit.setObject(cell.txtText.text! as String, forKey: "title")
		let arrPath = NSArray(object: cell.indexPath)
                arrContent.replaceObjectAtIndex(i, withObject: dcit)
        self.tableView.reloadRowsAtIndexPaths(arrPath as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)

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


    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        _ = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "handleTimer:", userInfo: nil, repeats: false)

        


    }
    func handleTimer(t: NSTimer)
    {
                tableView.reloadData()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AlbumCell = tableView.dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumCell
        cell.delegate = self
        cell.indexPath = indexPath
        let dict: NSDictionary

        dict = arrContent[indexPath.row] as! NSDictionary

        if (tableView.editing)
        {
            cell.lblText.hidden = true
            cell.txtText.hidden = false
        }
        else
        {
         cell.lblText.hidden = false
         cell.txtText.hidden = true
        }


		cell.lblText.text = dict.objectForKey("title") as! String
		cell.txtText.text = dict.objectForKey("title") as! String
        return cell
    }




    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }



    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
			arrContent.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


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
