//
//  StudentConvenience.swift
//  On the Map
//
//  Created by Rachel Paturi on 4/17/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import Foundation
import UIKit

extension StudentInformation {
    //MARK: GET functions
    
    func getStudentInformation(completionHandlerForStudentInformation:() -> Void) {

        let methodString = "\(Method.UdacityMethods.user)/\(self.userID!)"
        
        taskForGETMethod(methodString, parameters: [:], apiScheme: Constants.UdacityURL.ApiScheme, apiHost: Constants.UdacityURL.ApiHost, apiPath: Constants.UdacityURL.ApiPath) { (result, error) in
            
            guard let account = result["user"] as? [String : AnyObject] else {
                print("We could not find \(result["user"])")
                return
            }
            
            guard let nameFirst = account["first_name"] as? String else {
                print("We could not find \(result["first_name"]) in \(account)")
                return
            }
            
            guard let nameLast = account["last_name"] as? String else {
                print("We could not find \(result["last_name"]) in \(account)")
                return
            }
            
            self.firstName = nameFirst
            self.lastName = nameLast
        }
        
    }
    
    func getStudentLocation(completionHandlerForStudentLocation: (result: AnyObject!, error: NSError?) -> Void) {
        
        let methodString = "\(Method.ParseMethods.studentLocation)\(Method.ParseMethods.studentRecordLimit)"
        
        taskForGETMethod(methodString, parameters: [:], apiScheme: Constants.ParseURL.ApiScheme, apiHost: Constants.ParseURL.ApiHost, apiPath: Constants.ParseURL.ApiPath, completionHandlerForGET: {(parsedResult, error) in
            
            completionHandlerForStudentLocation(result: parsedResult, error: error)
        })
    }

    
    
    //MARK: POST functions
    func loginToUdacity(username: String, password: String, completionHandlerForLogin: (()) -> Void) {
        
        let jsonBody: String = "{\"udacity\": {\"\(JSONBodyKeys.Udacity.username)\": \"\(username)\", \"\(JSONBodyKeys.Udacity.password)\": \"\(password)\"}}"
        
        taskForPOSTMethod(Method.UdacityMethods.session, parameters: [:], jsonBody: jsonBody, apiScheme: Constants.UdacityURL.ApiScheme, apiHost: Constants.UdacityURL.ApiHost, apiPath: Constants.UdacityURL.ApiPath, completionHandlerForPOST: {(result, error) in
        
            guard let account = result["account"] as? [String : AnyObject] else {
                print("We could not find \(result["account"])")
                return
            }
            
            guard let userKey = account["key"] as? String else {
                print("We could not find \(result["key"]) in \(account)")
                return
            }
            
            self.userID = userKey
            
            completionHandlerForLogin()
            
        })
    }
}

