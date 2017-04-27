//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/15/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var studentLocations = [StudentInformation]()
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        studentLocations = StudentDataSource.sharedInstance.students

    }

    @IBAction func refresh(_ sender: Any) {
        setUIEnabled(false)
        ParseClient.sharedInstance().getStudentLocations(100) { (success, error) in
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                if success {
                    self.studentLocations = StudentDataSource.sharedInstance.students
                    self.tableView.reloadData()
                } else {
                    self.alert(title: "Refresh error", message: error?.description)
                }
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
    // The udacity session was already deleted as part of the ParseClient (ParseConvenience).authenticate function, so there is no real "logout" needed here.
        StudentDataSource.sharedInstance.reset()
        dismiss(animated: true, completion: nil)
    }
    
    func setUIEnabled(_ enabled: Bool) {
        
        // adjust login button alpha
        if enabled {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return studentLocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* Get cell type */
        let cellReuseIdentifier = "StudentTableViewCell"
        let student = studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        /* Set cell defaults */
        cell?.textLabel!.text = student.name
        cell?.imageView!.image = UIImage(named: "icon_pin")
        cell?.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var message: String?
        if let urlString = studentLocations[indexPath.row].location?.mediaURL {
            if let url = URL(string: urlString) {
                let app = UIApplication.shared
                if app.canOpenURL(url) {
                    app.open(url)
                } else {
                    message = "URL cannot be opened: \(urlString)"
                }
            } else {
                message = "URL cannot be used: \(urlString)"
            }
        } else {
            message = "There is no URL for this student location"
        }
        if let message = message {
            alert(title: "URL Error", message: message)
        } else {
            // Only deselect the row if there was no error
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
