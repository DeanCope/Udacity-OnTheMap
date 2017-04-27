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
                    let alert = UIAlertController(title: "Refresh error", message: error?.description, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)                }
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
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
        let url = studentLocations[indexPath.row].location!.mediaURL
        UIApplication.shared.open(URL(string: url)!)
    }

}
