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

    
    @IBOutlet weak var enterLocation: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelPost(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func findLocation(sender: AnyObject) {
        
    }
    

}
