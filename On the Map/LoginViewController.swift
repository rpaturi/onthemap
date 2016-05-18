//
//  LoginViewController.swift
//  On the Map
//
//  Created by Rachel Paturi on 3/24/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["email"]
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Allow user to sign up for a Udacity.com account
    @IBAction func signUpForUdacityAccount(sender: AnyObject) {
        if let url = NSURL(string:"https://www.udacity.com/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    //Login with Udacity username and password
    @IBAction func loginButton(sender: AnyObject) {
        if usernameTextField.text == "" || passwordTextField.text == "" {
            loginErrorLabel.text = "Please enter in your username and password"
        } else {
            loginErrorLabel.text = "Verifying..."
            
            appDelegate.studentInfo.loginToUdacity(usernameTextField.text!, password: passwordTextField.text!, completionHandlerForLogin: { (result, errorAlert) in
                
                if let theErrorAlert = errorAlert {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loginErrorLabel.text = ""
                        self.presentViewController(theErrorAlert, animated: true, completion: nil)
                        return
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.activityIndicator.hidden = false
                        self.activityIndicator.startAnimating()
                        if self.activityIndicator.isAnimating() == true {
                            self.view.alpha = 0.5
                        }
                        
                        //Once logged in, show the map view in the tab bar controller
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
                        self.presentViewController(controller, animated: false, completion: nil)
                    }
                }
            })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("Logged Out")
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        appDelegate.studentInfo.facebookLogin(FBSDKAccessToken.currentAccessToken().tokenString)
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
        self.presentViewController(controller, animated: false, completion: nil)
        
    }
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
