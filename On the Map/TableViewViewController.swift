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


}
