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
        
        let object = PFObject(className: "TestObject")
        object["foo"] = "bar"
        object.saveInBackgroundWithBlock { (success, error) in
            if success && error == nil {
                print("Saved")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

