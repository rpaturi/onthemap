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
        /* 1. Set the parameters */
        let limit : Int = 100
        
        /* 2 Build the URL*/
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?\(limit)?order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 3. Configure the request */
        let session = NSURLSession.sharedSession()
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!. This is your status code: \(response)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                print("We could not find \(parsedResult["results"])")
                return
            }
            
            /* 6. Use the data */
            self.appDelegate.studentInfo.studentInfo = Student.studentsFromResults(results)
            if let studentInfo = self.appDelegate.studentInfo.studentInfo {
                self.createMapAnnotation(studentInfo)
            }
            
        }
        /* Resume Task */
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createMapAnnotation(students : [Student]) {
        for student in students {
            let annotation = MKPointAnnotation()
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = "\(student.mediaURL)"
            annotation.coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
