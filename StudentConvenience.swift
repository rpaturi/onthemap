//
//  StudentConvenience.swift
//  On the Map
//
//  Created by Rachel Paturi on 4/17/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

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
    
    func postLocationToParse(mapString: String, mediaURL: String, coordinates: CLLocationCoordinate2D, completionHandlerForPostLocation: (()) -> Void ) {
        guard let userIDNumber = self.userID else {
            print("Optional values of \(self.userID) was not unwrapped properly")
            return
        }
        
        guard let theFirstName = self.firstName, let theLastName = self.lastName else {
            print("Optional values of \(self.firstName) and \(self.lastName) was not unwrapped properly")
            return
        }
        
        let methodString = "\(Method.ParseMethods.studentLocation)"
        
        let jsonBody: String = "{\"uniqueKey\": \"\(userIDNumber)\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinates.latitude), \"longitude\": \(coordinates.longitude)}"
        
        taskForPOSTMethod(methodString, parameters: [:], jsonBody: jsonBody, apiScheme: Constants.ParseURL.ApiScheme, apiHost: Constants.ParseURL.ApiHost, apiPath: Constants.ParseURL.ApiPath, completionHandlerForPOST: {(result, error) in
            
            completionHandlerForPostLocation()
        })
    }
}

