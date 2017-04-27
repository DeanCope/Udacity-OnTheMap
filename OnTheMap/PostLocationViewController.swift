//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/19/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController, MKMapViewDelegate {
    
    var place: CLPlacemark!
    var placeName = ""
    var student: StudentInformation?

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var urlText: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //urlText.text = "http://www.google.com"

        displayAnnotationOnMap()
    }
    
    private func displayAnnotationOnMap() {
        
        if let location = place.location {
            let lat = CLLocationDegrees(location.coordinate.latitude)
            let long = CLLocationDegrees(location.coordinate.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Create the annotation and set its properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = placeName
            //  annotation.subtitle = studentInformation.mediaURL
            
            // Add the annotation to the map.
            self.mapView.addAnnotation(annotation)
            mapView.camera.altitude = 2000
            
            mapView.setCenter(coordinate, animated: true)
        }
    }

    
    @IBAction func submit(_ sender: Any) {
        // POST (if new) or PUT (if replace) pin location
        
        guard let urlString = urlText.text, let _ = URL(string: urlString) else {
            alert(message: "Enter a valid URL")
            return
        }
        
        setUIEnabled(false)
        
        let newLocation = StudentLocation(mediaURL: urlString,
                                          latitude: Float((place.location?.coordinate.latitude)!),
                                          longitude: Float((place.location?.coordinate.longitude)!),
                                          mapString: placeName)
        
        student!.newLocation = newLocation

        ParseClient.sharedInstance().postOrPutLocation(student!) {(success, error) in
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                if success {
                    self.displaySuccess(titleString: "Success", messageString: "Your new location was posted")
                } else {
                    self.alert(message: error?.description)
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // display success
    func displaySuccess(titleString: String, messageString: String?) {
        let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default){(alert: UIAlertAction!) in self.cancel(self)})
        self.present(alertController, animated: true)  }
    
    func setUIEnabled(_ enabled: Bool) {
        submitButton.isEnabled = enabled
        cancelButton.isEnabled = enabled
        
        // adjust map alpha
        if enabled {
            mapView.alpha = 1.0
            activityIndicator.stopAnimating()
        } else {
            mapView.alpha = 0.5
            activityIndicator.startAnimating()
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
