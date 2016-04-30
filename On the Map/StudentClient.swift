//
//  StudentClient.swift
//  On the Map
//
//  Created by Rachel Paturi on 4/17/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import Foundation
import UIKit

class StudentInformation {
    // MARK: Properties
    var studentInfo: [Student]?
    var firstName: String?
    var lastName: String?
    
    // shared session
    var session = NSURLSession.sharedSession()
    
    // authentication state
    var requestToken: String? = nil
    var sessionID : String? = nil
    var userID : String? = nil
    
    // MARK: Initializers
    
    init() {
    
    }
    
    //MARK: Task for GET
    
    
    //MARK: Task for POST
    func taskForPOSTMethod(method: String, var parameters: [String:AnyObject], jsonBody: String, apiScheme: String, apiHost: String, apiPath: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* 1. Set the parameters */
        
        /* 2 Build the URL*/
        let request = NSMutableURLRequest(URL: urlFromParameters(apiScheme, host: apiHost, path: apiPath, parameters: parameters, withPathExtension: method))
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
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
            
            completionHandlerForPOST(result: parsedResult, error: error)
            
        }
        
        /* Resume Task */
        task.resume()
        
        return task
    
    }
    
    //Create URL from parameters 
    
    private func urlFromParameters(scheme: String, host: String, path: String, parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    
    }
    
    
    
    
    
    //MARK: Shared Instance
    
    class func sharedInstance() -> StudentInformation {
        struct Singleton {
            static var sharedInstance = StudentInformation()
        }
        return Singleton.sharedInstance
    }
}