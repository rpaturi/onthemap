//
//  StudentInfo.swift
//  On the Map
//
//  Created by Rachel Paturi on 5/23/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import Foundation

class StudentData {
    var studentData: [Student]?
    
    init() {
        
    }
    
    //MARK: Shared Instance
    
    class func sharedInstance() -> StudentData {
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }

}