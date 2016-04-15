//
//  ViewController.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/7/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let newUser = AdminUser()
//        newUser["username"] = "pbush27"
//        newUser["email"] = "pmb0015@auburn.edu"
//        newUser["name"] = "Patrick Bush"
//        newUser.password = "TestPass"
//        newUser.signUpInBackgroundWithBlock { (success, error) in
//            if success && error == nil {
//                print("Saved")
//            }
//        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let department = Department()
        department.departmentName = "Yourmomology"
        MIMSUser.currentUser()!.department = department
        MIMSUser.currentUser()!.saveInBackgroundWithBlock { (success, error) in
            if success && error == nil {
                print("Success")
            }
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

