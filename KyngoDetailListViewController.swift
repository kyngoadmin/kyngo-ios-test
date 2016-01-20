
//
//  KyngoDetailListViewController.swift
//  Kyngo
//
//  Created by Abhi on 1/21/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import ReachabilitySwift

class KyngoDetailCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewItem: UIImageView!
}
class KyngoDetailListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableViewDetailList: UITableView!
    var arrayOFKyngoListsDetails : NSArray = NSArray()
    var dictOfCacheImages : NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        showMBProgressHudInView(self.view, labelText: "Please wait...")
        if isNetworkReachable() {
            self.callGetApiWithWithMethod("http://jsonplaceholder.typicode.com/photos", completionHandler: { (response) -> Void in
                self.hideMBProgressHudInView(self.view)
                if response.result.isSuccess {
                    self.arrayOFKyngoListsDetails = (response.result.value as? NSArray)!
                    self.tableViewDetailList.reloadData()
                }else{
                    self.showAlert("Kyngo", message: "It seems you are not connected to internet.", cancelButtonTitle: "Ok");
                }
            })
        }else{
            showAlert("Kyngo", message: "It seems you are not connected to internet.", cancelButtonTitle: "Ok");
        }
    }
    private func configureTableView()->Void {
        
        self.tableViewDetailList.estimatedRowHeight = 100.0;
        self.tableViewDetailList.rowHeight = UITableViewAutomaticDimension;
    }
    

    //MARK:- UITableView Data Source & Delegate 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOFKyngoListsDetails.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KyngoDetailCell") as! KyngoDetailCell
        
        cell.labelTitle.text = arrayOFKyngoListsDetails.objectAtIndex(indexPath.row).valueForKey("title") as? String
        let strImageURl = arrayOFKyngoListsDetails.objectAtIndex(indexPath.row).valueForKey("thumbnailUrl") as? String
        
        if (dictOfCacheImages.objectForKey(strImageURl!) != nil) {
        cell.imageViewItem.image = dictOfCacheImages.valueForKey(strImageURl!) as? UIImage
        }else {
           
            cell.imageViewItem.image = UIImage(named: "icon")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let data = NSData(contentsOfURL: NSURL(string: strImageURl!)!)
                if data != nil {
                    let image = UIImage(data: data!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.imageViewItem.image = image
                        self.dictOfCacheImages.setObject(image!, forKey: strImageURl!)
                    })

                }
            })
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ItemDetail", sender: arrayOFKyngoListsDetails.objectAtIndex(indexPath.row))
    }
        // Do any additional setup after loading the view.
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ItemDetail" {
        
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("KyngoItemDetailViewController") as! KyngoItemDetailViewController
            vc = segue.destinationViewController as! KyngoItemDetailViewController
            vc.dict = sender as? NSDictionary
            
        }
    }
    
    //MARK: API Handling

}
