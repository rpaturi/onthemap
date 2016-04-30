//
//  Constants .swift
//  On the Map
//
//  Created by Rachel Paturi on 4/29/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import Foundation

extension StudentInformation {

    struct Constants {
        struct UdacityURL {
            static let ApiScheme = "https"
            static let ApiHost = "www.udacity.com"
            static let ApiPath = "/api"
        }
        
        struct ParseURL {
            static let ApiScheme = "https"
            static let ApiHost = "api.parse.com"
            static let ApiPath = "/1/classes"
        }
    }
    
    struct Method {
        struct UdacityMethods {
            static let session = "/session"
            static let user = "/users"
        }
        
        struct ParseMethods {
            static let studentLocation = "/StudentLocation"
        }

    }
    
    struct JSONBodyKeys {
        struct Parse {
            static let uniqueKey = "uniqueKey"
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let mapString = "mapString"
            static let mediaURL = "mediaURL"
            static let latitude = "latitude"
            static let longitude = "longitude"
        }
        struct Udacity {
            static let username = "username"
            static let password = "password"
        }
    }
}

