//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Rachel Paturi on 3/24/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController {
    
    var location: CLLocationCoordinate2D?
    
    @IBOutlet weak var enterLocation: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.hidesWhenStopped = true
        self.view.alpha = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func cancelPost(sender: AnyObject) {
        
        enterLocation.text = nil
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func findLocation(sender: AnyObject) {
        //Check that user has entered in a location
        if enterLocation.text?.isEmpty == true {
            self.view.alpha = 1.0
            let alert = UIAlertController(title: "Missing Location", message: "Please enter in a location", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        } else {
            activityIndicator.startAnimating()
            
            if activityIndicator.isAnimating() == true {
                self.view.alpha = 0.5
            } else {
                self.view.alpha = 1.0
            }
            
            //Find user's location from search term
            if let userLocation = enterLocation.text {
                let request = MKLocalSearchRequest()
                request.naturalLanguageQuery = userLocation
                request.region = mapView.region
                
                let search = MKLocalSearch(request: request)
                search.startWithCompletionHandler { (response, error) in
                    
                    guard let response = response else {
                        let geocodingError = createAlertError("Location Not Found", message: "Unfortunately, we could not find that location on the map. Please try again.")
                        self.presentViewController(geocodingError, animated: true, completion: nil)
                        
                        self.activityIndicator.stopAnimating()
                        
                        print("Search error: \(error)")
                        return
                    }
                    
                    let responseItem = response.mapItems[0]
                    self.location = responseItem.placemark.coordinate
                    
                    //Segue to AddURLViewController with location information
                    self.performSegueWithIdentifier("postLocation", sender: self.location as? AnyObject)

                }
            }
        }
    }
    
    //Send location data to AddURLVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postLocation" {
            self.activityIndicator.stopAnimating()
            
            if let addURLVC = segue.destinationViewController as? AddURLViewController {
                addURLVC.mapString = enterLocation.text
                addURLVC.location = location
            }
        }
    }
}

extension InformationPostingViewController: UITextFieldDelegate {
    //dismiss keyboard when screen is tapped
    @IBAction func dismissKeyboard(sender: AnyObject) {
        if enterLocation.isFirstResponder() {
            enterLocation.resignFirstResponder()
        }
    }
    
    //dismiss keyboard when "return" on keyboard is tapped
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
