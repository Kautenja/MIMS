//
//  HourPickerViewController.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/27/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class HourPickerViewController: UIViewController {

    var delegate: HourPickerViewDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func pickedDate(sender: UIButton) {
        if let pickerView = pickerView as? UIDatePicker {
            delegate?.didPickNewDate(pickerView.date)
        }
    }
    
    @IBAction func cancelPresses(sender: UIButton) {
        //self.dismissSemiModalView()
    }

}

protocol HourPickerViewDelegate {
    func didPickNewDate(date: NSDate)
}
