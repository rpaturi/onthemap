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
    
    func getStudentInformation(completionHandlerForStudentInformation:(result: AnyObject?, errorAlert: UIAlertController?) -> Void) {

        let methodString = "\(Method.UdacityMethods.user)/\(self.userID!)"
        
        taskForGETMethod(methodString, parameters: [:], apiScheme: Constants.UdacityURL.ApiScheme, apiHost: Constants.UdacityURL.ApiHost, apiPath: Constants.UdacityURL.ApiPath) { (result, error) in
            
            guard error == nil else {
                if error != nil {
                    
                    let alertError: UIAlertController
                    
                    alertError = createAlertError("Sorry!", message: "The request timed out." )
                    
                    completionHandlerForStudentInformation(result: nil, errorAlert: alertError)
                }
                return
            }
            
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
            
            completionHandlerForStudentInformation(result: result, errorAlert: nil)
        }
        
    }
    
    func getStudentLocation(completionHandlerForStudentLocation: (result: AnyObject!, error: NSError?) -> Void) {
        
        let methodString = "\(Method.ParseMethods.studentLocation)\(Method.ParseMethods.studentRecordLimit)"
        
        taskForGETMethod(methodString, parameters: [:], apiScheme: Constants.ParseURL.ApiScheme, apiHost: Constants.ParseURL.ApiHost, apiPath: Constants.ParseURL.ApiPath, completionHandlerForGET: {(parsedResult, error) in
            
            if let error = error {
                completionHandlerForStudentLocation(result: nil, error: error) 
            } else {
                completionHandlerForStudentLocation(result: parsedResult, error: nil)
            }
        })
    }

    
    
    //MARK: POST functions
    func loginToUdacity(username: String, password: String, completionHandlerForLogin: (result: AnyObject?, errorAlert: UIAlertController?) -> Void) {
        
        let jsonBody: String = "{\"udacity\": {\"\(JSONBodyKeys.Udacity.username)\": \"\(username)\", \"\(JSONBodyKeys.Udacity.password)\": \"\(password)\"}}"
        
        taskForPOSTMethod(Method.UdacityMethods.session, parameters: [:], jsonBody: jsonBody, apiScheme: Constants.UdacityURL.ApiScheme, apiHost: Constants.UdacityURL.ApiHost, apiPath: Constants.UdacityURL.ApiPath, completionHandlerForPOST: {(result, error) in
            
            guard error == nil else{
                if let theError = error {
                    
                    let alertError: UIAlertController
                    
                    switch theError.code {
                        case 0: alertError = createAlertError("Login Error", message: "Wrong user name and/or password. Please try again")
                        case 1: alertError = createAlertError("Network Failure", message: "We are sorry! We are not able to connect to the network")
                        default: alertError = createAlertError("Sorry!", message: theError.localizedDescription)
                    }
                    completionHandlerForLogin(result: nil, errorAlert: alertError)
                }
                return
            }
            
            guard let account = result["account"] as? [String : AnyObject] else {
                print("We could not find \(result["account"])")
                return
            }
            
            guard let userKey = account["key"] as? String else {
                print("We could not find \(result["key"]) in \(account)")
                return
            }
            self.userID = userKey
            print(userKey)
            
            completionHandlerForLogin(result: result, errorAlert: nil)
            
        })
    }
    
    func facebookLogin(fbAccessToken: String, completionHandlerForFBLogin: (result: AnyObject?, error: NSError?) -> Void){
        let methodString = "\(Method.UdacityMethods.session)"
        
        let jsonBody: String = "{\"facebook_mobile\": {\"access_token\": \"\(fbAccessToken)\"}}"
        
        taskForPOSTMethod(methodString, parameters: [:], jsonBody: jsonBody, apiScheme: Constants.UdacityURL.ApiScheme, apiHost: Constants.UdacityURL.ApiHost, apiPath: Constants.UdacityURL.ApiPath, completionHandlerForPOST: {(result, error) in
                guard error == nil else {
                    print(error)
                    return
                }
            
                guard let account = result["account"] as? [String : AnyObject] else {
                    print("We could not find \(result["account"])")
                    return
                }
            
                guard let userKey = account["key"] as? String else {
                    print("We could not find \(result["key"]) in \(account)")
                    return
                }
            self.userID = userKey
            print(userKey)
            
            completionHandlerForFBLogin(result: result, error: error)
        
        })
    }
    
    func postLocationToParse(mapString: String, mediaURL: String, coordinates: CLLocationCoordinate2D, completionHandlerForPostLocation: (result: AnyObject?, errorAlert: UIAlertController?) -> Void ) {
        guard let userIDNumber = self.userID else {
            print("Optional values of \(self.userID) was not unwrapped properly")
            return
        }
        
        guard let theFirstName = self.firstName, let theLastName = self.lastName else {
            print("Optional values of \(self.firstName) and \(self.lastName) was not unwrapped properly")
            return
        }
        
        let methodString = "\(Method.ParseMethods.studentLocation)"
        
        let jsonBody: String = "{\"uniqueKey\": \"\(userIDNumber)\", \"firstName\": \"\(theFirstName)\", \"lastName\": \"\(theLastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinates.latitude), \"longitude\": \(coordinates.longitude)}"
        
        taskForPOSTMethod(methodString, parameters: [:], jsonBody: jsonBody, apiScheme: Constants.ParseURL.ApiScheme, apiHost: Constants.ParseURL.ApiHost, apiPath: Constants.ParseURL.ApiPath, completionHandlerForPOST: {(result, error) in
            
            guard error == nil else{
                if let theError = error {
                    let alertError: UIAlertController
                    
                    switch theError.code {
                    case 1: alertError = createAlertError("Network Failure", message: "We are sorry! We are not able to connect to the network")
                    case 3: alertError = createAlertError("Post Failed", message: "Unfortunately, we could not submit your location. Please try again")
                    default: alertError = createAlertError("Sorry!", message: theError.localizedDescription)
                    }
                    completionHandlerForPostLocation(result: nil, errorAlert: alertError)
                }
                return
            }
            
            completionHandlerForPostLocation(result: result, errorAlert: nil)
        })
    }
}

