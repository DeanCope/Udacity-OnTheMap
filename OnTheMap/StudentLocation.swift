//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/24/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import Foundation

struct StudentLocation {
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    var mapString: String?

    
    //MARK: Initializers
    // construct a StudentLocation from a dictionary
    // This is a failable initializer.  If any of the required properties are not found, then no instance is created.
    init?(dictionary: [String:AnyObject]) {
        
        if let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String,
            let latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Float,
            let longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Float,
            let mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String {
                self.mediaURL = mediaURL
                self.latitude = latitude
                self.longitude = longitude
                self.mapString = mapString
            }
        else {
            return nil
        }
    }
    init?(mediaURL: String, latitude: Float, longitude: Float, mapString: String) {
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
    }

}
