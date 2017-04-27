//
//  StudentDataSource.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/27/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import Foundation

class StudentDataSource {
    var students = [StudentInformation]()
    static let sharedInstance = StudentDataSource()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    func reset() {
        students = [StudentInformation]()
    }
}
