//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/6/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    // MARK: Authentication (GET) Methods
    
    /*
     Steps for Authentication...
     
     Step 1: Use POST to create a session and get a session id and user id
     Step 2: Use GET to get the users first and last name
     Step 3: Use DELETE to delete the session
     */
    func authenticate(email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: UdacityClientError?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        getUserID(email: email, password: password) { (success, userID, error) in
            
            if success {
                // success! we have the User.
                self.getUserInfo(userID!) { (success, udacityUser, error) in
                    
                    if success {
                        self.currentUser = udacityUser
                        self.deleteSession() { (success, error) in
                                completionHandlerForAuth(success, error)
                        }
                    } else {
                        completionHandlerForAuth(success, error)
                    }
                }
            } else {
                completionHandlerForAuth(success, error)
            }
        }
    }
    
    // MARK: GET Convenience Methods
    
    private func getUserInfo(_ userID: String, completionHandlerForUserInfo: @escaping (_ success: Bool, _ result: UdacityUser?, _ error: UdacityClientError?) -> Void) {
        
        /* 1. Specify method (if has {key}) */
        var mutableMethod: String = UdacityClient.Methods.UserInfo
        mutableMethod = substituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: String(userID))!
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: [String:AnyObject]()) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForUserInfo(false, nil, error)
            } else {
                
                if let results = results?[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] {
                    let user = UdacityUser(dictionary: results)
                    completionHandlerForUserInfo(true, user, nil)
                } else {
                    completionHandlerForUserInfo(false, nil, .parseFailed(detail: "Could not find \(UdacityClient.JSONResponseKeys.User) in \(results.debugDescription)"))
                }
            }
        }
    }
    
    
    // MARK: POST Convenience Methods
    
    
    private func getUserID(email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ userID: String?, _ error: UdacityClientError?) -> Void) {
        
        // Get the userid by creating a session via POST
        
        /* 1. Specify HTTP body */
        
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.UserName)\": \"\(email)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(Methods.Session, parameters: [String: AnyObject](), jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForAuth(false, nil, error)
            } else {
                if let results = results?[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject] {
                    if let userKey = results[UdacityClient.JSONResponseKeys.UserKey] as? String {
                        completionHandlerForAuth(true, userKey, nil)
                    } else {
                        completionHandlerForAuth(false, nil, .parseFailed(detail: "Could not find user key"))
                    }
                } else {
                    completionHandlerForAuth(false, nil, .parseFailed(detail: "Could not parse post for Session"))
                }
            }
        }
    }
    
    
    // MARK: DELETE Convenience Methods
    
    private func deleteSession(completionHandlerForDeleteSession: @escaping (_ success: Bool, _ error: UdacityClientError? ) -> Void) {
        
        /* 1. Specify method (if has {key}) */
    
        var headerValues = [String:String]()
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            headerValues["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        /* 2. Make the request */
        let _ = taskForDELETEMethod(Methods.Session, headerValues: headerValues) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForDeleteSession(false, error)
            } else {
                
                if let _ = results?[UdacityClient.JSONResponseKeys.Session] as? [String:AnyObject] {
                    completionHandlerForDeleteSession(true, nil)
                } else {
                    completionHandlerForDeleteSession(false, .parseFailed(detail: "Could not find \(UdacityClient.JSONResponseKeys.Session) in \(results.debugDescription)" ))
                }
            }
        }
    }
}
