//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/6/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//


// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Errors
    public enum UdacityClientError: Error {
        case invalidIdOrPassword
        case connectionFailed(method: String, errorString: String)
        case noStatusCode(method: String)
        case badStatusCode(code: String)
        case noDataReturned
        case parseFailed(detail: String)
        case otherError(reason: String)
        
        var description: String {
            switch self {
            case .invalidIdOrPassword: return "Id or password is invalid"
            case .connectionFailed(let method, let errorString): return "Connection failed for \(method): \(errorString)"
            case .noStatusCode(let method): return "No status code received for \(method)"
            case .badStatusCode(let code): return "Bad status code received: \(code)"
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
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let SessionURL = "https://www.udacity.com/api/session/"
        static let UserURL = "https://www.udacity.com/api/users/{user_id}"
        static let SignUpURL = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Account
        static let Session = "/session"
        static let UserInfo = "/users/{user_id}"
        
    }

    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "user_id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {

    }
    
    // MARK: Header Field Keys
    struct HeaderKeys {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    // MARK: Header Field Values
    struct HeaderValues {
        static let Json = "application/json"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }

    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // MARK: Account
        static let Account = "account"
        static let UserKey = "key"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let Session = "session"
        static let Registered = "registered"
        
    }
}
