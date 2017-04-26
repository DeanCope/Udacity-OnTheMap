//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/12/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//


// This struct represents a student location for display on the map and other views

struct StudentInformation {
    //    MARK: Properties
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    // Most students have just a single location
    var location: StudentLocation?
    // newlocation is for the currently logged on student to specify a new location
    // to send to the server
    var newLocation: StudentLocation?
    var name: String {
        return "\(firstName) \(lastName)"
    }
    
    //MARK: Initializers
    // construct a StudentInformation from a dictionary
    // This is a failable initializer.  If any of the required properties are not found, then no instance is created.
    init?(dictionary: [String:AnyObject]) {
        
        if let objectId = dictionary[ParseClient.JSONResponseKeys.ObjectId] as? String,
        let uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String,
        let firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String,
        let lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String {
            self.objectId = objectId
            self.uniqueKey = uniqueKey
            self.firstName = firstName
            self.lastName = lastName
            location = StudentLocation(dictionary: dictionary)
            // If there's no valid location then skip this student
            if location == nil {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var students = [StudentInformation]()
        
        // iterate through array of dictionaries, each StudentInformation is a dictionary
        for result in results {
            if let student = StudentInformation(dictionary: result) {
                students.append(student)
            }
        }
        
        return students
    }
    
}
