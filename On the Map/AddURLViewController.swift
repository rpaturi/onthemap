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
    
    var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var enterURL: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        if let theLocation = location {
            self.mapView.centerCoordinate = theLocation
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = theLocation
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let theLocation = location {
//            self.mapView.centerCoordinate = theLocation
//            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = theLocation
//            self.mapView.addAnnotation(annotation)
//        }
    }
    
    @IBAction func cancelPost(sender: AnyObject) {
        enterURL.text = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
}
