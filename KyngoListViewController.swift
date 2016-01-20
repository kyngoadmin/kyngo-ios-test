//
//  KyngoListViewController.swift
//  Kyngo
//
//  Created by Abhi on 1/21/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import ReachabilitySwift

class KyngoListViewController: UITableViewController {

    var arrayOFKyngoLists : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        showMBProgressHudInView(self.view, labelText: "Please wait...")
        if isNetworkReachable() {
            self.callGetApiWithWithMethod("http://jsonplaceholder.typicode.com/albums", completionHandler: { (response) -> Void in
                self.hideMBProgressHudInView(self.view)
                if response.result.isSuccess {
                self.arrayOFKyngoLists = (response.result.value as? NSArray)!
                    self.tableView.reloadData()
                }else{
                    self.showAlert("Kyngo", message: "It seems you are not connected to internet.", cancelButtonTitle: "Ok");
                }
            })
        }else{
            showAlert("Kyngo", message: "It seems you are not connected to internet.", cancelButtonTitle: "Ok");
        }
    }

    //MARK:- Private Methods 
    
    private func configureTableView()->Void {
    
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    //MARK:- Close Button Action
    @IBAction func actionOnCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (arrayOFKyngoLists.count)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KyngoList", forIndexPath: indexPath)
        let labelTitle = cell.viewWithTag(1) as! UILabel
        labelTitle.text = "\(indexPath.row+1).) \(arrayOFKyngoLists.objectAtIndex(indexPath.row).valueForKey("title") as! String      )"  // Configure the cell...

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("Detail", sender: nil)
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
    //MARK: API Handling
     func callGetApiWithWithMethod(url:URLStringConvertible ,completionHandler:(response:Response<AnyObject, NSError>) -> Void)
    {
        Alamofire.request(.GET, url).responseJSON { (Response) -> Void in
            completionHandler(response: Response);
        }
    }
    //MARK: - Reachablity
    func isNetworkReachable()->Bool {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            return false
        }
        
        let networkStatus: Int = reachability.currentReachabilityStatus.hashValue
        return networkStatus != 0
    }
    
    //MARK: MBProgress-HUD
    internal  func showMBProgressHudInView(view:UIView,labelText:String)->Void{
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true);
        hud.labelText = labelText
    }
    
    internal  func hideMBProgressHudInView(view:UIView)->Void{
        MBProgressHUD.hideAllHUDsForView(view, animated: true);
    }
    
    //MARK: AlertView
    internal func showAlert(title:String , message : String , cancelButtonTitle:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}
