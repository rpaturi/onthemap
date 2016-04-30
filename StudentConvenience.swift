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

