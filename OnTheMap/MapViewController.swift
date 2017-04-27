//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dean Copeland on 4/12/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayAnnotationsOnMap()
    }
    
    private func displayAnnotationsOnMap() {
        var annotations = [MKPointAnnotation]()
        
        let studentLocations = StudentDataSource.sharedInstance.students
        
        for studentInformation in studentLocations {
            
            let lat = CLLocationDegrees(studentInformation.location!.latitude)
            let long = CLLocationDegrees(studentInformation.location!.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Here we create the annotation and set its coordinate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = studentInformation.name
            annotation.subtitle = studentInformation.location!.mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    @IBAction func refresh(_ sender: Any) {
        setUIEnabled(false)
        ParseClient.sharedInstance().getStudentLocations(100) { (success, error) in
            performUIUpdatesOnMain {
                self.setUIEnabled(true)
                if success {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.displayAnnotationsOnMap()
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
    

    

}
