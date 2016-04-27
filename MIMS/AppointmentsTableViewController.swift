//
//  AppointmentsTableViewController.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/21/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit
import THCalendarDatePicker

class AppointmentsTableViewController: UITableViewController, SWRevealViewControllerDelegate {

    var menuButton: UIButton!
    var appointments: [Appointment]?
    var appointmentEdited: Appointment?
    
    lazy var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(false)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(true)
        dp.setDisableFutureSelection(false)
        //dp.autoCloseCancelDelay = 5.0
        dp.selectedBackgroundColor = UIColor.blackColor() //UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp.currentDateColor = UIColor.lightGrayColor()// UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp.currentDateColorSelected = UIColor.darkGrayColor() //UIColor.yellowColor()
        return dp
    }()
    
    lazy var hourDatePicker: UIDatePicker = {
        let screenSize = UIScreen.mainScreen().bounds
        var hourPicker = UIDatePicker() //UIDatePicker(frame: CGRect(x: screenSize.minX, y: screenSize.maxY - 100, width: screenSize.width, height: 100))
        hourPicker.datePickerMode = UIDatePickerMode.Time
        let currentDate = self.newlySelectedDate
        hourPicker.minimumDate = currentDate
        hourPicker.minuteInterval = 10
        return hourPicker
    }()
    
    lazy var newlySelectedDate: NSDate = NSDate()
    lazy var hourTextField: UITextField = {
       let textField = UITextField()
        return textField
    }()
    
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
        
        self.tableView.tableFooterView = UIView()
        
        self.queryAppointments()
        
        let nib1 = UINib(nibName: "MIMSCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "MIMS")
    }

    func queryAppointments() {
        ParseClient.queryAppointments { (appointments, error) in
            if error == nil && appointments != nil {
                self.appointments = appointments
                self.tableView.reloadData()
            }
        }
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
        //return self.name.count
        guard appointments != nil else {
            return 0
        }
        return appointments!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MIMS", forIndexPath: indexPath) as! MIMSTableViewCell
        
        let appointment = appointments![indexPath.row]
        let patient = appointment.associatedPatient
        let scheduledTime = appointment.timeScheduled
        let detail0 = scheduledTime?.getDateForAppointment()
        let detail1 = scheduledTime?.getTimeForAppointment()
        
        cell.titleLabel.text = patient.name
        cell.detailLabel1.text = detail0!
        cell.detailLabel2.text = detail1!
        cell.detailLabel3.text = detail2.first
        cell.sideInformationLabel.text = detail3.first
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
            
            let cancelAction = UIAlertAction(title: "Cancel Appointment", style: .Destructive, handler: { (action) in
                guard let appointment = self.appointments?[indexPath.row] else {
                    return
                }
                ParseClient.deleteObject(appointment) { (success, error) in
                    if !success {
                        //TODO: Report an error
                    }
                }
            })
            let goBackAction = UIAlertAction(title: "Don't Cancel Appointment", style: UIAlertActionStyle.Cancel, handler: nil)

            shareMenu.addAction(goBackAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        let completeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Complete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            let shareMenu = UIAlertController(title: nil, message: "Complete the Appointment?", preferredStyle: .ActionSheet)
            
            let doneAction = UIAlertAction(title: "Finish!", style: UIAlertActionStyle.Default, handler: {(action) in
                guard let appointment = self.appointments?[indexPath.row] else {
                    return
                }
                appointment.markAsCompleted()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)

            shareMenu.addAction(doneAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        let rescheduleAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Reschedule" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            guard let appointment = self.appointments?[indexPath.row] else {
                return
            }
            self.appointmentEdited = appointment
            
            self.datePicker.date = NSDate()
            self.datePicker.setDateHasItemsCallback({(date:NSDate!) -> Bool in
                let tmp = (arc4random() % 30) + 1
                return tmp % 5 == 0
            })
            self.presentSemiViewController(self.datePicker, withOptions: [
                self.convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.3 as Float,
                self.convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 1.0 as Float,
                self.convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
                ])
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

extension AppointmentsTableViewController: THDatePickerDelegate {
    func datePickerDonePressed(datePicker: THDatePickerViewController!) {
        newlySelectedDate = datePicker.date.dateByAddingTimeInterval(NSTimeInterval(25200))
        dismissSemiModalView()
        let hourController = UIAlertController(title: "Pick a new time", message: "Between 7AM and 8PM", preferredStyle: .Alert)
        hourController.addTextFieldWithConfigurationHandler { (textField) in
            textField.inputView = self.hourDatePicker
            let formatter = NSDateFormatter()
            formatter.timeStyle = .LongStyle
            let date = formatter.stringFromDate(self.newlySelectedDate)
            //print(date)
            textField.placeholder = date
            self.hourDatePicker.addTarget(self, action: #selector(AppointmentsTableViewController.updateText(_:)), forControlEvents: .AllEvents)
            self.hourTextField = textField
        }
        hourController.addAction(UIAlertAction(title: "Reschedule", style: .Default, handler: { (action) in
            self.tableView.endEditing(true)
            self.newlySelectedDate = self.hourDatePicker.date
            self.appointmentEdited!.timeScheduled = self.newlySelectedDate
            self.appointmentEdited?.saveInBackgroundWithBlock({ (success, error) in
                if success && error == nil {
                    self.queryAppointments()
                } else {
                    //TODO: Present alert for unable to complete request
                }
            })
        }))
        hourController.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: nil))
        self.presentViewController(hourController, animated: true, completion: nil)

        
    }
    
    func datePickerCancelPressed(datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func updateText(sender: UIDatePicker) {
        
        let components = NSCalendar.currentCalendar().components(
            [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Weekday, NSCalendarUnit.WeekdayOrdinal, NSCalendarUnit.WeekOfYear],
            fromDate: sender.date)
        
        if components.hour < 7 {
            components.hour = 7
            components.minute = 0
            sender.setDate(NSCalendar.currentCalendar().dateFromComponents(components)!, animated: true)
        }
        else if components.hour > 20 {
            components.hour = 20
            components.minute = 0
            sender.setDate(NSCalendar.currentCalendar().dateFromComponents(components)!, animated: true)
        }
        else {
            print("Everything is good.")
        }
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .LongStyle
        let date = formatter.stringFromDate(sender.date)
        self.hourTextField.text = date
    }
    
    
    /* https://vandadnp.wordpress.com/2014/07/07/swift-convert-unmanaged-to-string/ */
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        /* Coded by Vandad Nahavandipoor */
        let value = Unmanaged<CFStringRef>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFStringRef
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
}
