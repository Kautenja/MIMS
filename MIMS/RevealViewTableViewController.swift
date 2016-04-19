//
//  RevealViewTableViewController.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/19/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class RevealViewTableViewController: UITableViewController {

    @IBOutlet weak var logoutCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell == logoutCell {
            self.logout({ (success, error) in
                if success && error == nil {
                    let loginVC = self.storyboard?.instantiateInitialViewController()
                    self.presentViewController(loginVC!, animated: true, completion: nil)
                } else {
                    let alert = createAlert("Uh oh, we couldn't log you out", errorMessage: "Would you like to try again?")
                    alert.addAction(UIAlertAction(title: "Yes, please.", style: .Default, handler: { (action) in
                        self.logout({ (success, error) in
                            
                        })
                    }))
                    alert.addAction(UIAlertAction(title: "No, thanks.", style: .Destructive, handler: nil))
                }
            })
            
        }
    }
    
    func logout(completion: (success: Bool, error: NSError?)->()) {
        ParseClient.logout(MIMSUser.currentUser()!) { (success, error) in
            if success && error == nil {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error!)
            }
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
