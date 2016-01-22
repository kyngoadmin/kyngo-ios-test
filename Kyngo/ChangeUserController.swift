//
//  ChangeUserController.swift
//  Kyngo
//
//  Created by Tish on 21/01/16.
//  Copyright © 2016 Kyngo. All rights reserved.
//

import UIKit

class ChangeUserController: UITableViewController {
    
    var users: [User]!
    
    // MARK: - UITableViewController
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! NameValueCell
        cell.nameLabel.text = String(users[indexPath.row].id)
        cell.valueLabel.text = users[indexPath.row].username
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        AppState.sharedInstance.currentUserId = users[indexPath.row].id
        navigationController?.popViewControllerAnimated(true)
    }
}