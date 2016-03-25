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
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    var appDelegate: AppDelegate!
    
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
            loginToUdacity()
        }
    }
    
    func loginToUdacity() {
        /* 1. Set the parameters */
        
        /* 2 Build the URL*/
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(usernameTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 3. Configure the request */
        let session = NSURLSession.sharedSession()
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!. This is your status code: \(response)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }

            /* Remove the first 5 characters from data per Udacity API Requirements */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            //print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            /* 6. Use the data */
            guard let account = parsedResult["account"] as? [String : AnyObject] else {
                print("We could not find \(parsedResult["account"])")
                return
            }
            
//            guard let userKey = account["key"] as? Int else {
//                print("We could not find \(parsedResult["key"]) in \(account)")
//                return
//            }
//            self.appDelegate.userID = userKey
            
            dispatch_async(dispatch_get_main_queue()) {
                self.loginErrorLabel.text = ""
                //Once logged in, show the map view in the tab bar controller
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
                self.presentViewController(controller, animated: true, completion: nil)
            }

        }
        
        /* Resume Task */
        task.resume()
        
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
