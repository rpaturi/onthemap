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
    
    //Create URL from parameters
    
    func urlFromParameters(scheme: String, host: String, path: String, parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
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

    
    //MARK: Task for GET
    func taskForGETMethod(method: String, parameters: [String:AnyObject], apiScheme: String, apiHost: String, apiPath: String, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* 1. Set the parameters */
        
        /* 2 Build the URL*/
        let request = NSMutableURLRequest(URL: urlFromParameters(apiScheme, host: apiHost, path: apiPath, parameters: parameters, withPathExtension: method))
        
        if apiHost == "api.parse.com" {
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        /* 3. Configure the request */
        let session = NSURLSession.sharedSession()
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func sendError(error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!. This is your status code: \(response)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let parsedResult: AnyObject!
            
            if apiHost == "www.udacity.com" {
                /* Remove the first 5 characters from data per Udacity API Requirements */
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                
                /* 5. Parse the data */
                
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    print("Could not parse the data as JSON: '\(newData)'")
                    return
                }
            } else {
                /* 5. Parse the data */
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
            }

            /* 6. Use the data */
            completionHandlerForGET(result: parsedResult, error: error)
            
        }
        /* Resume Task */
        task.resume()
        return task
    }
    
    //MARK: Task for POST
    func taskForPOSTMethod(method: String, parameters: [String:AnyObject], jsonBody: String, apiScheme: String, apiHost: String, apiPath: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* 1. Set the parameters */
        
        /* 2 Build the URL*/
        let request = NSMutableURLRequest(URL: urlFromParameters(apiScheme, host: apiHost, path: apiPath, parameters: parameters, withPathExtension: method))
        request.HTTPMethod = "POST"
        
        if apiHost == "www.udacity.com" {
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if apiHost == "api.parse.com" {
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
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
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            
            if apiHost == "www.udacity.com" {
                /* Remove the first 5 characters from data per Udacity API Requirements */
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                
                /* 5. Parse the data */
                
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
                } catch {
                    print("Could not parse the data as JSON: '\(newData)'")
                    return
                }
            } else {
                /* 5. Parse the data */
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
            }
            
            completionHandlerForPOST(result: parsedResult, error: error)
            
        }
        
        /* Resume Task */
        task.resume()
        
        return task
    
    }
    
    //MARK: Shared Instance
    
    class func sharedInstance() -> StudentInformation {
        struct Singleton {
            static var sharedInstance = StudentInformation()
        }
        return Singleton.sharedInstance
    }
}