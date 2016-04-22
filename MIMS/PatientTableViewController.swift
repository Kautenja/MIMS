//
//  PatientTableViewController.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/21/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit
import ParseUI

class PatientTableViewController: UITableViewController, SWRevealViewControllerDelegate {

    var menuButton: UIButton!
    
    let name = ["Abe Lincon","Billy Manchester","Clyde S. Dale","Doug Chandler","Elvira Moody", "Fransis Ogertree", "Hilary Clinton", "Jacob Jenkins", "Kelly Price", "Low Mill", "Micheal Scott", "No Name", "Oliver Queen"]
    
    let detail0 = ["1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678","1(555)234-5678"]
    let detail1 = ["542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830","542 Oak Meadow Ln, Auburn Al. 36830"]
    let detail2 = ["March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983","March 25, 1983"]
    let detail3 = ["Male","Male","Male","Male","Female","Female","Female","Male","Female","Male","Male","Male","Male","Male"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib1 = UINib(nibName: "MIMSCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "MIMS")

        menuButton = UIButton(frame: CGRectMake(0, 0, 20, 20))
        menuButton.setBackgroundImage(UIImage(named: "Side menu.png"), forState: .Normal)
        let menuButtonItem = UIBarButtonItem(customView: menuButton)
        self.navigationItem.setLeftBarButtonItem(menuButtonItem, animated: true)
        self.title = "Patients"
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
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
