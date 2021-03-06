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
    var mapString: String?
    
    @IBOutlet weak var enterURL: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Make sure the location information was sent from InformationPostingViewController
        if let theLocation = location {
            //Set map coordinates and zoom into the location
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

    }
    
    @IBAction func cancelPost(sender: AnyObject) {
        enterURL.text = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitLocation(sender: AnyObject) {
        
        if let theMapString = mapString, let theLocation = location, let urlText = enterURL.text {
            
            StudentInformation.sharedInstance().postLocationToParse(theMapString, mediaURL: urlText, coordinates: theLocation, completionHandlerForPostLocation: { (result, errorAlert) in
                if let theErrorAlert = errorAlert {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(theErrorAlert, animated: true, completion: nil)
                        return
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
