//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/19/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {
    
    var place: CLPlacemark!
    
    var student: StudentInformation?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var locationText: UITextField!
    
    @IBOutlet weak var findButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //locationText.text = "Stamford, CT"
        
        setUIEnabled(false)
        let currentUser = UdacityClient.sharedInstance().currentUser!
        
        // Call ParseClient to see if user already has a location
        ParseClient.sharedInstance().getStudentInformation(currentUser.userKey!) { (success, information, error) in
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                if success {
                    self.student = information
                    var text = "You already have a location"
                    if let loc = information!.location!.mapString {
                        text = text + " named \(loc)"
                    }
                    text = text + ".  If you proceed, it will be replaced by the new location."
                    self.displayAlert(titleString: "Warning", messageString: text)
                } else {
                    self.displayAlert(titleString: "Error", messageString: error?.localizedDescription)
                }
            }
        }
    }

    @IBAction func find(_ sender: Any) {
        setUIEnabled(false)
        // do forward geocoding
        findLocation() { (success, errorString) in
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                if success {
                    // if found, present next VC
                    self.performSegue(withIdentifier: "ShowOnMap", sender: self)
                } else {
                    // else display alert:
                    // Location not found, try again
                    self.displayAlert(titleString: "Error", messageString: errorString)
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func findLocation(completionHandlerForFindLocation: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let geocoder = CLGeocoder()
        guard let location = locationText.text else {
            completionHandlerForFindLocation(false, "Location text is empty")
            return
        }
        geocoder.geocodeAddressString(location) {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemark = placemarks?.first {
                self.place = placemark
                completionHandlerForFindLocation(true, nil)
                
            } else {
                completionHandlerForFindLocation(false, "Location could not be found")
            }
        }
    }
    // display an error if something goes wrong
    func displayAlert(titleString: String, messageString: String?) {
        let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "ShowOnMap") {
            let destinationController = segue.destination as! PostLocationViewController
            destinationController.student = student
            destinationController.placeName = locationText.text!
            destinationController.place = self.place
        }
    }
    
    func setUIEnabled(_ enabled: Bool) {
    
        locationText.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            findButton.alpha = 1.0
            activityIndicator.stopAnimating()
        } else {
            findButton.alpha = 0.5
            activityIndicator.startAnimating()
        }
    }

}
