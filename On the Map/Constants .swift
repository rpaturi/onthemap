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
            static let ApiHost = "parse.udacity.com"
            static let ApiPath = "/parse/classes"
        }
    }
    
    struct Method {
        struct UdacityMethods {
            static let session = "/session"
            static let user = "/users"
        }
        
        struct ParseMethods {
            static let studentLocation = "/StudentLocation"
            static let studentRecordLimit = "limit"
        }
    }
    
    struct HTTPHeader {
        struct HeaderField {
            static let parseAppID = "X-Parse-Application-Id"
            static let parseAPIkey = "X-Parse-REST-API-Key"
        }
        
        struct HeaderValue {
            static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            static let parseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
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

