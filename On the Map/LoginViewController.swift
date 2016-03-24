//
//  LoginViewController.swift
//  On the Map
//
//  Created by Rachel Paturi on 3/24/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
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

}


extension LoginViewController: UITextFieldDelegate {
    //dismiss keyboard when screen is tapped
    @IBAction func dismissKeyboard(sender: AnyObject) {
        if usernameTextField.isFirstResponder() || passwordTextField.isFirstResponder() {
            usernameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
        }
    }
    
    //dismiss keyboard when "return" on keyboard is tapped
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
