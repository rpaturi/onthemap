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
            
            let latDegrees = 0.05
            let longDegrees = 0.05
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDegrees, longDegrees)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(theLocation, span)
            
            self.mapView.setRegion(region, animated: true)
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

extension AddURLViewController: UITextFieldDelegate {
    //dismiss keyboard when screen is tapped
    @IBAction func dismissKeyboard(sender: AnyObject) {
        if enterURL.isFirstResponder() {
            enterURL.resignFirstResponder()
        }
    }
    
    //dismiss keyboard when "return" on keyboard is tapped
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
