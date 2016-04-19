//
//  LoginViewController.swift
//  MIMS
//
//  Created by Patrick Bush on 4/18/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        do {
            try ParseClient.login(usernameTextField!.text!, password: passwordTextField!.text!, completion: { (error) in
                if error == nil {
                    self.performSegueWithIdentifier("PresentHomeFromLogin", sender: self)
                } else {
                    let alert = createAlert("Uh oh, we encountered an error!", errorMessage: error!.localizedDescription)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } catch ParseErrorCodes.InvalidPasswordLength(message: let message) {
            let alert = createAlert("Uh oh, we encountered an error!", errorMessage: message)
            self.presentViewController(alert, animated: true, completion: nil)
            print(message)
        }
        catch ParseErrorCodes.InvalidUsernameLength(message: let message){
            let alert = createAlert("Uh oh, we encountered an error!", errorMessage: message)
            self.presentViewController(alert, animated: true, completion: nil)
            print(message)
        }
        catch let error {
            print(error)
        }
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
