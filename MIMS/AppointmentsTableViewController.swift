//
//  AppointmentsTableViewController.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/21/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class AppointmentsTableViewController: UITableViewController, SWRevealViewControllerDelegate {

    var menuButton: UIButton!
    
    let name = ["Abe Lincon","Billy Manchester","Clyde S. Dale","Doug Chandler","Elvira Moody", "Fransis Ogertree", "Hilary Clinton", "Jacob Jenkins", "Kelly Price", "Low Mill", "Micheal Scott", "No Name", "Oliver Queen"]
    
    let detail0 = ["Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016","Tuesday, May 15, 2016"]
    let detail1 = ["8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am","8am - 10am"]
    let detail2 = [" "," "," "," "," "," "," "," "," "," "," "," "," "," "]
    let detail3 = [" "," "," "," "," "," "," "," "," "," "," "," "," "," "]

    
    override func viewDidLoad() {
        super.viewDidLoad()


        menuButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
        menuButton.setBackgroundImage(UIImage(named: "Side menu.png"), forState: .Normal)
        let menuButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.setLeftBarButtonItem(menuButtonItem, animated: true)
        self.title = "Appointments"
        self.navigationController?.navigationBar.translucent = false
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.revealViewController().delegate = self
        }
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        
        let nib1 = UINib(nibName: "MIMSCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "MIMS")
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
        return self.name.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MIMS", forIndexPath: indexPath) as! MIMSTableViewCell
        
        cell.titleLabel.text = name[indexPath.row]
        cell.detailLabel1.text = detail0[indexPath.row]
        cell.detailLabel2.text = detail1[indexPath.row]
        cell.detailLabel3.text = detail2[indexPath.row]
        cell.sideInformationLabel.text = detail3[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    //editing functions
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        // 1
        let cancelAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Cancel" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let shareMenu = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel Appointment", style: UIAlertActionStyle.Destructive, handler: nil)
            let goBackAction = UIAlertAction(title: "Don't Cancel Appointment", style: UIAlertActionStyle.Cancel, handler: nil)

            shareMenu.addAction(goBackAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        let completeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Complete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let shareMenu = UIAlertController(title: nil, message: "Complete the Appointment?", preferredStyle: .ActionSheet)
            
            let doneAction = UIAlertAction(title: "Finish!", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)

            shareMenu.addAction(doneAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        let rescheduleAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Reschedule" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let shareMenu = UIAlertController(title: nil, message: "Reschedule the Appointment?", preferredStyle: .Alert)
            
            let doneAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)

            
            shareMenu.addAction(doneAction)
            shareMenu.addAction(cancelAction)
            
            
            shareMenu.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Enter a time: 8am - 10pm"
            }

            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        
        rescheduleAction.backgroundColor = UIColor.blueColor()
        completeAction.backgroundColor = UIColor.lightGrayColor()
        return [cancelAction,rescheduleAction,completeAction]
    }


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
