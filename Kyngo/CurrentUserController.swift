//
//  UserController.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class CurrentUserController: UITableViewController, ApiManagerDelegate {
    
    // MARK: - CurrentUserController
    
    let apiManager = ApiManager()
    
    var users = [User]()
    var currentUserAttributes = [(String, String)]()
    
    func updateCurrentUser() {
        if let user = users.filter({ $0.id == AppState.sharedInstance.currentUserId }).first {
            let userMirror = Mirror(reflecting: user)
            currentUserAttributes = userMirror.children.map({ ($0.label!, "\($0.value)") })
            tableView.reloadData()
        }
    }
    
    func performDataRequest() {
        apiManager.getUsers { (users) -> Void in
            self.users = users
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl?.endRefreshing()
                self.updateCurrentUser()
            }
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.beginRefreshing()
        refreshControl?.addTarget(self, action: "performDataRequest", forControlEvents: .ValueChanged)
        
        apiManager.delegate = self
        performDataRequest()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        updateCurrentUser()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChangeUser" {
            (segue.destinationViewController as! ChangeUserController).users = users
        }
    }
    
    // MARK: - UITableViewController
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserAttributes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell", forIndexPath: indexPath) as! NameValueCell
        cell.nameLabel.text = currentUserAttributes[indexPath.row].0
        cell.valueLabel.text = currentUserAttributes[indexPath.row].1
        return cell
    }
}