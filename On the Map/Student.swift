//
//  Student.swift
//  On the Map
//
//  Created by Rachel Paturi on 3/28/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import UIKit

struct Student {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var createdAt: NSString
    var updatedAt: NSString
    
    init (dictionary: [String:AnyObject]) {
        objectId = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        createdAt = dictionary["createdAt"] as! NSString
        updatedAt = dictionary["updatedAt"] as! NSString
    }
    
    static func studentsFromResults(results: [[String:AnyObject]]) -> [Student] {
        var students = [Student]()
        
        // iterate through array of dictionaries, each Student is a dictionary
        for result in results {
            students.append(Student(dictionary: result))
        }
        
        return students
    }
}

