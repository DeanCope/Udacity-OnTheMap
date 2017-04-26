//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/12/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension ParseClient {
    
    // MARK: Errors
    public enum ParseClientError: Error {
        case connectionFailed(method: String, errorString: String)
        case noStatusCode(method: String)
        case badStatusCode(code: String, url: String)
        case noDataReturned
        case parseFailed(detail: String)
        case otherError(reason: String)
        
        var description: String {
            switch self {
            case .connectionFailed(let method, let errorString): return "Connection failed for \(method): \(errorString)"
            case .noStatusCode(let method): return "No status code received for \(method)"
            case .badStatusCode(let code): return "Bas status code received: \(code)"
            case .noDataReturned: return "No data returned"
            case .parseFailed(let detail): return "Parse failed: \(detail)"
            case .otherError(let reason): return "Error: \(reason)"
            }
        }
    }
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let SessionURL = "https://www.udacity.com/api/session/"
        static let UserURL = "https://www.udacity.com/api/users/{user_id}"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let StudentLocation = "/StudentLocation"
        static let UserInfo = "/users/{user_id}"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "user_id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
        static let UniqueKey = "uniqueKey"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let OrderUpdatedAtDescending = "-updatedAt"
    }
    
    // MARK: Header Field Keys
    struct HeaderKeys {
        static let AppId = "X-Parse-Application-Id"
        static let APIKey = "X-Parse-REST-API-Key"
        static let Accept = "accept"
        static let ContentType = "Content-Type"
    }

    // MARK: Header Field Values
    struct HeaderValues {
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let Json = "application/json"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // MARK: Account
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
    }
}
