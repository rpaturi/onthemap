//
//  MapViewController.swift
//  On the Map
//
//  Created by Rachel Paturi on 3/24/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!
    
    var students: [Student] = [Student]()
    //Parse Student Location Parameters
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                self.mapView.mapType = MKMapType.Standard
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.hidden = true
        self.view.alpha = 1.0
        mapView.delegate = self
        
        //Store student's first and last name
        appDelegate.studentInfo.getStudentInformation { }
        
        getStudentLocation()
    }

    @IBAction func refreshData(sender: AnyObject) {
        getStudentLocation()
    }
    
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

        //Get student location data from Parse server and create map annotations
        appDelegate.studentInfo.getStudentLocation { (result, error) in
            
            if let error = error {
                print(error)
                let alert = UIAlertController(title: "Data Error", message: "Unfortunately, the data did not load properly. Please try again", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            guard let results = result["results"] as? [[String:AnyObject]] else {
                print("We could not find \(result["results"])")
                return
            }
            
            self.appDelegate.studentInfo.studentInfo = Student.studentsFromResults(results)
            if let studentInfo = self.appDelegate.studentInfo.studentInfo {
                self.createMapAnnotation(studentInfo)
            }
        }
    }
   
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let annotation = view.annotation else {
                return
            }
            
            if let subtitleURL = annotation.subtitle {
                UIApplication.sharedApplication().openURL(NSURL(string: subtitleURL!)!)
            }
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        
        if self.activityIndicator.isAnimating() == true {
            self.view.alpha = 0.5
        }
        
        appDelegate.studentInfo.logout {(result, error) in
            if let theResult = result {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginVC")
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
    }

}
