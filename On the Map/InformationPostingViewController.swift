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
    
    override func viewWillAppear(animated: Bool) {

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
            
            let alert = UIAlertController(title: "Missing Location", message: "Please enter in a location", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        } else {
            
            if let userLocation = enterLocation.text {
                let request = MKLocalSearchRequest()
                request.naturalLanguageQuery = userLocation
                request.region = mapView.region
                
                let search = MKLocalSearch(request: request)
                search.startWithCompletionHandler { (response, error) in
                    guard let response = response else {
                        print("Search error: \(error)")
                        return
                    }
                    
                    let responseItem = response.mapItems[0]
                    self.location = responseItem.placemark.coordinate
                    
                    self.performSegueWithIdentifier("postLocation", sender: self.location as? AnyObject)

                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postLocation" {
            if let addURLVC = segue.destinationViewController as? AddURLViewController {
                
                addURLVC.location = location
                print("I am sending the location: \(addURLVC.location) I think")
                
            }
        }
    }
    

}
