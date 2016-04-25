//
//  DashboardTableViewController.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/19/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class DashboardTableViewController: UITableViewController, SWRevealViewControllerDelegate {

    var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
        menuButton.setBackgroundImage(UIImage(named: "Side menu.png"), forState: .Normal)
        let menuButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.setLeftBarButtonItem(menuButtonItem, animated: true)
        self.title = ""
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
        
        guard let userType = MIMSUser.currentUser()!.userType else {
            flag = ""
            return
        }
        self.title = userType
        flag = userType

    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 3
        }
        else if section == 1
        {
            return pendingRequest.count
        }
        else
        {
            return perscriptionRequest.count
        }
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MIMS", forIndexPath: indexPath) as! MIMSTableViewCell
        if flag == UserTypes.AdminUser.rawValue {
            if indexPath.section == 0 {
                cell.titleLabel.text = actions0[indexPath.row]
                cell.detailLabel1.text = detail00[indexPath.row]
                cell.detailLabel2.text = detail01[indexPath.row]
                cell.detailLabel3.text = detail02[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
            if indexPath.section == 1
            {
                cell.titleLabel.text = pendingRequest[indexPath.row]
                cell.detailLabel1.text = pendingDetail0[indexPath.row]
                cell.detailLabel2.text = pendingDetail1[indexPath.row]
                cell.detailLabel3.text = pendingDetail2[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
            if indexPath.section == 2
            {
                cell.titleLabel.text = perscriptionRequest[indexPath.row]
                cell.detailLabel1.text = perscriptionDetail0[indexPath.row]
                cell.detailLabel2.text = perscriptionDetail1[indexPath.row]
                cell.detailLabel3.text = perscriptiongDetail2[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
        }
        else if flag == UserTypes.OperationalUser.rawValue {
            if indexPath.section == 0
            {
                cell.titleLabel.text = detail10[indexPath.row]
                cell.detailLabel1.text = detail11[indexPath.row]
                cell.detailLabel2.text = detail12[indexPath.row]
                cell.detailLabel3.text = " "
                cell.sideInformationLabel.text = " ";
                return cell
            }
            if indexPath.section == 1
            {
                cell.titleLabel.text = pendingRequest[indexPath.row]
                cell.detailLabel1.text = pendingDetail0[indexPath.row]
                cell.detailLabel2.text = pendingDetail1[indexPath.row]
                cell.detailLabel3.text = pendingDetail2[indexPath.row]
                cell.sideInformationLabel.text = "Active";
                return cell
            }
            if indexPath.section == 2
            {
                cell.titleLabel.text = perscriptionRequest[indexPath.row]
                cell.detailLabel1.text = perscriptionDetail0[indexPath.row]
                cell.detailLabel2.text = perscriptionDetail1[indexPath.row]
                cell.detailLabel3.text = perscriptiongDetail2[indexPath.row]
                cell.sideInformationLabel.text = "Waiting";
                return cell
            }
        }
        else if flag == UserTypes.TechnicalUser.rawValue {
            if indexPath.section == 0
            {
                cell.titleLabel.text = actions2[indexPath.row]
                cell.detailLabel1.text = detail20[indexPath.row]
                cell.detailLabel2.text = detail21[indexPath.row]
                cell.detailLabel3.text = detail22[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
            if indexPath.section == 1
            {
                cell.titleLabel.text = pendingRequest[indexPath.row]
                cell.detailLabel1.text = pendingDetail0[indexPath.row]
                cell.detailLabel2.text = pendingDetail1[indexPath.row]
                cell.detailLabel3.text = pendingDetail2[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
            if indexPath.section == 2
            {
                cell.titleLabel.text = perscriptionRequest[indexPath.row]
                cell.detailLabel1.text = perscriptionDetail0[indexPath.row]
                cell.detailLabel2.text = perscriptionDetail1[indexPath.row]
                cell.detailLabel3.text = perscriptiongDetail2[indexPath.row]
                cell.sideInformationLabel.text = " ";
                return cell
            }
        }
        else {
            cell.titleLabel.text = actions2[indexPath.row]
            cell.detailLabel1.text = detail20[indexPath.row]
            cell.detailLabel2.text = detail21[indexPath.row]
            cell.detailLabel3.text = detail22[indexPath.row]
            cell.sideInformationLabel.text = " ";
            return cell
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch flag {
        case UserTypes.AdminUser.rawValue:
            if section == 0 {
                return "Action"
            }
            else if section == 1 {
                return "Pending Requests"
            }
            else {
                return "Perscriptions Sent"
            }
        case UserTypes.OperationalUser.rawValue:
            if section == 0 {
                return "Next Appointment"
            }
            else if section == 1 {
                return "Pending Requests"
            }
            else {
                return "Perscriptions Sent"
            }
        case UserTypes.TechnicalUser.rawValue:
            if section == 0 {
                return "Action"
            }
            if section == 1 {
                return "Pending Requests"
            }
            else {
                return "Perscriptions Sent"
            }
        default:
            if section == 0 {
                return "Action"
            }
            if section == 1 {
                return "Pending Requests"
            }
            if section == 2 {
                return "Perscriptions Sent"
            }
        }
        return " "
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
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
