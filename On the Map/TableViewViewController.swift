//
//  TableViewViewController.swift
//  On the Map
//
//  Created by Rachel Paturi on 3/24/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import UIKit

class TableViewViewController: UIViewController, UITableViewDataSource{

    var appDelegate: AppDelegate!
    var studentCount: Int!
    var studentData: [Student]!
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        if let student = self.appDelegate.studentInfo.studentInfo {
            studentData = student
            studentCount = student.count
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentInformationCell", forIndexPath: indexPath)
        
        let student = studentData[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL)"
        return cell
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        
        //Get student location data from Parse server
        appDelegate.studentInfo.getStudentLocation { (result, error) in
            guard let results = result["results"] as? [[String:AnyObject]] else {
                print("We could not find \(result["results"])")
                return
            }
            
            self.appDelegate.studentInfo.studentInfo = Student.studentsFromResults(results)
            if let studentInfo = self.appDelegate.studentInfo.studentInfo {
                self.studentData = studentInfo
                self.studentCount = studentInfo.count
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentTableView.reloadData()
                    return
                }
                
            }
        }
    }
    


}
