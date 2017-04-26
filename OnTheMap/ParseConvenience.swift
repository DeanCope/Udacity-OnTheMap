//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/12/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: GET Convenience Methods
    // Get a list of student locations
    func getStudentLocations(_ limit: Int?, completionHandlerForStudentLocations: @escaping (_ success: Bool, _ error: ParseClientError?) -> Void) {
        
        /* 1. Specify parameters */
        
        var parameters = [String:AnyObject]()
        if let limit = limit {
            parameters[ParseClient.ParameterKeys.Limit] = limit as AnyObject
        }
        parameters[ParseClient.ParameterKeys.Order] = ParseClient.ParameterValues.OrderUpdatedAtDescending as AnyObject
        
        /* 2. Make the request */
        let _ = taskForGETMethod(ParseClient.Methods.StudentLocation, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentLocations(false, error)
            } else {
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    self.students = StudentInformation.studentsFromResults(results)
                    completionHandlerForStudentLocations(true, nil)
                } else {
                    completionHandlerForStudentLocations(false, .parseFailed(detail: "Could not parse getStudentLocations"))
                }
            }
        }
    }
    
    // Get a single student location
    func getStudentInformation(_ userKey: String, completionHandlerForStudentInformation: @escaping (_ success: Bool, _ student: StudentInformation?, _ error: ParseClientError?) -> Void) {
        
        /* 1. Specify parameters */
        
        var parameters = [String:AnyObject]()
            parameters[ParseClient.ParameterKeys.Where] = "{\"\(ParseClient.ParameterKeys.UniqueKey)\":\"\(userKey)\"}" as AnyObject
        
        var student: StudentInformation? = nil
        /* 2. Make the request */
        let _ = taskForGETMethod(ParseClient.Methods.StudentLocation, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForStudentInformation(false, nil, error)
            } else {
                
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    if let result = results.first {
                        student = StudentInformation(dictionary: result)
                        completionHandlerForStudentInformation(true, student, nil)
                    }
                } else {
                    completionHandlerForStudentInformation(false, nil, .parseFailed(detail: "Could not parse getStudentInformation"))
                }
            }
        }
    }
    
    // MARK: PUT/POST Convenience Methods
    
    func postOrPutLocation(_ student: StudentInformation, completionHandlerForPutOrPostLocation: @escaping (_ success: Bool, _ error: ParseClientError?) -> Void) {
        
        getStudentInformation(student.uniqueKey) { (success, existingStudent, error) in
            if success {
                if let _ = existingStudent {
                    // A location already exists for this student, so do a PUT
                    self.putLocation(student) { (success, error) in
                        if success {
                            completionHandlerForPutOrPostLocation(true, nil)
                        } else {
                            completionHandlerForPutOrPostLocation(false, error)
                        }
                    }
                } else {
                    // No location already exists, so do a POST
                    self.postLocation(student) {(success, error) in
                        if success {
                            completionHandlerForPutOrPostLocation(true, nil)
                        } else {
                            completionHandlerForPutOrPostLocation(false, error)
                        }
                    }
                }
            } else {
                completionHandlerForPutOrPostLocation(false, error)
            }
        }
    }
    
    
    // MARK: POST Convenience Methods
   
    func postLocation(_ student: StudentInformation, completionHandlerForPostLocation: @escaping (_ success: Bool, _ error: ParseClientError?) -> Void) {

        
        /* 1. Specify HTTP body */
        
        let jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(student.uniqueKey)\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(student.firstName)\", \"\(ParseClient.JSONBodyKeys.LastName)\": \"\(student.lastName)\",\"\(ParseClient.JSONBodyKeys.MapString)\": \"\(student.newLocation!.mapString!)\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(student.newLocation!.mediaURL)\",\"\(ParseClient.JSONBodyKeys.Latitude)\": \(student.newLocation!.latitude), \"\(ParseClient.JSONBodyKeys.Longitude)\": \(student.newLocation!.longitude)}"
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(Methods.StudentLocation, parameters: [String: AnyObject](), jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPostLocation(false, error)
            } else {
                completionHandlerForPostLocation(true, nil)
            }
        }
    }
    
    // MARK: PUT Convenience Methods
    
    func putLocation(_ student: StudentInformation, completionHandlerForPutLocation: @escaping (_ success: Bool, _ error: ParseClientError?) -> Void) {
        
        
        /* 1. Specify HTTP body */

        let jsonBody = "{\"\(ParseClient.JSONBodyKeys.UniqueKey)\": \"\(student.uniqueKey)\", \"\(ParseClient.JSONBodyKeys.FirstName)\": \"\(student.firstName)\", \"\(ParseClient.JSONBodyKeys.LastName)\": \"\(student.lastName)\",\"\(ParseClient.JSONBodyKeys.MapString)\": \"\(student.newLocation!.mapString!)\", \"\(ParseClient.JSONBodyKeys.MediaURL)\": \"\(student.newLocation!.mediaURL)\",\"\(ParseClient.JSONBodyKeys.Latitude)\": \(student.newLocation!.latitude), \"\(ParseClient.JSONBodyKeys.Longitude)\": \(student.newLocation!.longitude)}"
        
        /* 2. Make the request */
        let method = "\(Methods.StudentLocation)/\(student.objectId)"
        let _ = taskForPUTMethod(method, parameters: [String: AnyObject](), jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPutLocation(false, error)
            } else {
                completionHandlerForPutLocation(true, nil)
            }
        }
    }

}

