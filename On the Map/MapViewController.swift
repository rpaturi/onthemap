//
//  MapViewController.swift
//  On the Map
//
//  Created by Rachel Paturi on 3/24/16.
//  Copyright © 2016 Rachel Paturi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
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
    

}
