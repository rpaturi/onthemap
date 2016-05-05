//
//  AddURLViewController.swift
//  On the Map
//
//  Created by Rachel Paturi on 5/4/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//


import UIKit
import CoreLocation
import MapKit

class AddURLViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    var location: CLLocationCoordinate2D?
    var mapString: String?
    
    @IBOutlet weak var enterURL: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        if let theLocation = location {
            self.mapView.centerCoordinate = theLocation
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = theLocation
            self.mapView.addAnnotation(annotation)
            self.mapView.centerCoordinate = theLocation
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the app delegate
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    @IBAction func cancelPost(sender: AnyObject) {
        enterURL.text = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitLocation(sender: AnyObject) {
        
        if let theMapString = mapString, let theLocation = location, let urlText = enterURL.text {
            
            appDelegate.studentInfo.postLocationToParse(theMapString, mediaURL: urlText, coordinates: theLocation, completionHandlerForPostLocation: { () in
                        
                    })
        }
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
}
