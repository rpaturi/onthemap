//
//  MapViewController.swift
//  On the Map
//
//  Created by Rachel Paturi on 3/24/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import UIKit
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var students: [Student] = [Student]()
    //Parse Student Location Parameters
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set map to standard map view
        self.mapView.mapType = MKMapType.Standard
        
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.hidden = true
        self.view.alpha = 1.0
        
        //Set map delegate
        mapView.delegate = self
        
        //Store student's first and last name
        StudentInformation.sharedInstance().getStudentInformation { (result, errorAlert) in
            
            if let theErrorAlert = errorAlert {
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(theErrorAlert, animated: true, completion: nil)
                    return
                }
            }
        }
        
        //Get student location data to create map pins
        getStudentLocation()
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        getStudentLocation()
    }
    
    //Create map pins for map view with the first name, last name, and media URL
    func createMapAnnotation(students : [Student]) {
        for student in students {
            let annotation = MKPointAnnotation()
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = "\(student.mediaURL)"
            annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
            mapView.addAnnotation(annotation)
        }

    }
    
    func getStudentLocation() {
        
        StudentInformation.sharedInstance().getStudentLocation2 { (result, error) in
            if error != nil {
                let alertError = createAlertError("Data Error", message: "Unfortunately, the data did not load properly. Please try again")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alertError, animated: true, completion: nil)
                    return
                }
            }
        }
        //Get student location data from Parse server and create map annotations
        
        StudentInformation.sharedInstance().getStudentLocation { (result, error) in
            
            if let error = error {
                let alertError = createAlertError("Data Error", message: "Unfortunately, the data did not load properly. Please try again")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(alertError, animated: true, completion: nil)
                    return
                }
            }
            
            guard let results = result["results"] as? [[String:AnyObject]] else {
                print("We could not find \(result["results"])")
                return
            }
            
            StudentData.sharedInstance().studentData = Student.studentsFromResults(results)
    
            if let studentData = StudentData.sharedInstance().studentData {
                self.createMapAnnotation(studentData)
            }
        }
    }
   
    //Create MKAnnotationView  and setup call out button so user can tap on the call out for media url
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            
            let rightButton: AnyObject! = UIButton(type: UIButtonType.DetailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    //Open student's media URL in Safari when you click on call out icon
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let annotation = view.annotation else {
                return
            }
            
            if let subtitleURL = annotation.subtitle {
                UIApplication.sharedApplication().openURL(NSURL(string: subtitleURL!)!)
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let alertError = createAlertError("Invalid URL", message: "Sorry this URL is invalid! Please try another link.")
                    self.presentViewController(alertError, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        if self.activityIndicator.isAnimating() == true {
            self.view.alpha = 0.5
        }
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            FBSDKLoginManager().logOut()
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC")
            self.presentViewController(controller, animated: true, completion: nil)
        } else {
            StudentInformation.sharedInstance().logout {(result, error) in
                if result != nil {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC")
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
        }
    }

}
