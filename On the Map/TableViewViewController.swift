//
//  TableViewViewController.swift
//  On the Map
//
//  Created by Rachel Paturi on 3/24/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class TableViewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var studentCount: Int!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.hidden = true
        self.view.alpha = 1.0
        
        //Find out how many tableView rows are needed
        if let student = StudentData.sharedInstance().studentData {
            studentCount = student.count
        }

    }
    
    //Set number of tableView rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentCount
    }
    
    //Format student Information cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentInformationCell", forIndexPath: indexPath)
        
        let student = StudentData.sharedInstance().studentData![indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL)"
        return cell
    }
    
    //Open student URL in default browser when tapped 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = StudentData.sharedInstance().studentData![indexPath.row]
        
        if UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL)!) == false {
            
            dispatch_async(dispatch_get_main_queue()) {
                let alertError = createAlertError("Invalid URL", message: "Sorry this URL is invalid! Please try another link.")
                self.presentViewController(alertError, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        
        //Get student location data from Parse server
        StudentInformation.sharedInstance().getStudentLocation { (result, error) in
            guard let results = result["results"] as? [[String:AnyObject]] else {
                print("We could not find \(result["results"])")
                return
            }
            
            StudentData.sharedInstance().studentData = Student.studentsFromResults(results)
            if let studentInfo = StudentData.sharedInstance().studentData {
                self.studentCount = studentInfo.count
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentTableView.reloadData()
                    return
                }
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        if self.activityIndicator.isAnimating() == true {
            self.view.alpha = 0.5
        }
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKLoginManager().logOut()
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC")
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            StudentInformation.sharedInstance().logout {(result, error) in
                if result != nil {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC")
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
        }
    }

}
