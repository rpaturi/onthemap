//
//  ErrorHandling.swift
//  On the Map
//
//  Created by Rachel Paturi on 5/15/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import Foundation
import UIKit

struct HttpError {
    let badRequestError = NSError(domain: "taskForPOST Bad Request", code: 0, userInfo: [NSLocalizedDescriptionKey : "Unfortunately, we could not verify your request"])
    let networkFailure = NSError(domain: "taskForPOST Network Failture", code: 1, userInfo: [NSLocalizedDescriptionKey : "Unfortunately, we could not connect to the network"])
    let geocodingFailure = NSError(domain: "MKLocalSearch geocoding", code: 2, userInfo: [NSLocalizedDescriptionKey : "Unfortunately, we could not find your location"])
    let postLocationFailure = NSError(domain: "postLocationToParse post location", code: 3, userInfo: [NSLocalizedDescriptionKey : "Unfortunately, we could not submit your location. Please try again"])
    let redirectError = NSError(domain: "taskForPOST redirect", code: 4, userInfo: [NSLocalizedDescriptionKey : "We are redirecting you to the correct screen"])
}

func createAlertError(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(action)
    return alert
}
