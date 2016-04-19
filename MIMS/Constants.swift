//
//  Constants.swift
//  MIMS
//
//  Created by Patrick M. Bush on 4/19/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import Foundation

func createAlert(message: String, errorMessage: String) -> UIAlertController {
    let alert = UIAlertController(title: message, message: errorMessage, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil))
    return alert
}