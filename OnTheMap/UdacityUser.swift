//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/11/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

// MARK: - UdacityUser

struct UdacityUser {
//    MARK: Properties
    var firstName: String?
    var lastName: String?
    var userKey: String?
    var registered: Bool?

    //MARK: Initializers
    // construct a UdacityUser from a dictionary
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as? String
        userKey = dictionary[UdacityClient.JSONResponseKeys.UserKey] as? String
        registered = dictionary[UdacityClient.JSONResponseKeys.Registered] as? Bool
    }
}
