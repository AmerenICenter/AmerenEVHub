//
//  ParkingSatelliteViewController.swift
//  Ameren EV Hub
//
//  Created by Rick Lewis on 5/26/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase

// MARK: - Constants

// Name of parking lot JSON file
let PARKING_LOT_JSON_FILENAME = "data/simpleSatelliteParkingLot"

// Latitude longitude of Ameren headquarters
let AMEREN_HQ_LATITUDE: CLLocationDegrees = 38.622604
let AMEREN_HQ_LONGITUDE: CLLocationDegrees = -90.209559
let AMEREN_HQ_LATITUDE_SPAN: CLLocationDegrees = 0.006488 / 2
let AMEREN_HQ_LONGITUDE_SPAN: CLLocationDegrees = 0.010014 / 2

// Icon size as a proportion of latitude range
let ICON_LATITUDE_RATIO: Double = 0.0001

// Icon size minimum and maximum
let ICON_SIZE_MINIMUM: Double = 10
let ICON_SIZE_MAXIMUM: Double = 50

// EV tower state codes
let TOWER_STATE_IDLE = 1
let TOWER_STATE_CONNECTED = 4
let TOWER_STATE_CHARGING = 5
let TOWER_STATE_FAULT = 6

class ParkingSatelliteViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlet Connections

    // Map subview
    @IBOutlet weak var satelliteMapView: MKMapView!
    
    // MARK: - Class Variables
    
    // Default map center, span, and region
    var defaultCenter: CLLocationCoordinate2D! = nil
    var defaultSpan: MKCoordinateSpan! = nil
    var defaultRegion: MKCoordinateRegion! = nil
    
    // Dictionary mapping parking spot states to UIImage objects
    var stateImages: [Int : UIImage] = [TOWER_STATE_IDLE : #imageLiteral(resourceName: "Free Symbol"), TOWER_STATE_CONNECTED : #imageLiteral(resourceName: "Complete Symbol"), TOWER_STATE_CHARGING : #imageLiteral(resourceName: "Charging Symbol"), TOWER_STATE_FAULT : #imageLiteral(resourceName: "Error Symbol")]
    
    // Parking spot index JSON object
    var spotLocations = [String : [CLLocationDegrees]]()
    
    // Annotation image view array
    var annotationImageViews = [UIImageView]()
    
    // Firebase database reference
    var parkingDatabaseRef: DatabaseReference!
    
    // MARK: - Overridden UIViewController Functions
    
    // ----------------------------------------------------------------
    // viewDidLoad - called whenever view controller's view is loaded
    //               on-screen; sets map scope
    // ----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(1)
        // Define center, span, and range
        defaultCenter = CLLocationCoordinate2D(latitude: AMEREN_HQ_LATITUDE, longitude: AMEREN_HQ_LONGITUDE)
        defaultSpan = MKCoordinateSpan(latitudeDelta: AMEREN_HQ_LATITUDE_SPAN, longitudeDelta: AMEREN_HQ_LONGITUDE_SPAN)
        defaultRegion = MKCoordinateRegion(center: defaultCenter, span: defaultSpan)
        
        print(2)
        // Set map type to satellite and set region
        satelliteMapView.mapType = MKMapType.hybrid
        satelliteMapView.setRegion(defaultRegion, animated: false)
        
        print(3)
        // Opens annotation JSON file
        do {
            let parkingLotJSONPath = Bundle.main.path(forResource: PARKING_LOT_JSON_FILENAME, ofType: "json")
            let parkingLotJSONText = try String(contentsOfFile: parkingLotJSONPath!)
            print(parkingLotJSONText)
            spotLocations = try JSONSerialization.jsonObject(with: parkingLotJSONText.data(using: String.Encoding.unicode)!, options:[]) as! [String : [CLLocationDegrees]]
        } catch {
            print (error)
        }

        print(4)
        // Creates an annotation for each spot in JSON object
        for (idString, coordinates) in spotLocations {
            let id = Int(idString)
            let coordinateObject = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
            let spotAnnotation = ParkingSpotAnnotation(coordinateObject, spotID: id!)
            satelliteMapView.addAnnotation(spotAnnotation)
        }
        
        print(5)
        // Queries database for tower states
        parkingDatabaseRef = Database.database().reference()
        parkingDatabaseRef.child("EVApp/EVAppData").observe(DataEventType.childAdded, with: recieveFirebaseData)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MKMapViewDelegate Functions
    
    // ----------------------------------------------------------------
    // mapView:viewFor: - constructs and delivers view for state of
    //                    given parking spot ID annotation
    // @param mapView - the current MKMapView, which I already have
    // @param annotation - the annotation to deliver a view for
    // @return - a new UIImageView with the given spot's state icon
    // ----------------------------------------------------------------
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let spotAnnotation = annotation as? ParkingSpotAnnotation {
            let annotationView = MKAnnotationView(annotation: spotAnnotation, reuseIdentifier: spotAnnotation.title)
            let dimension = min(ICON_SIZE_MAXIMUM, max(ICON_SIZE_MINIMUM, satelliteMapView.region.span.latitudeDelta / ICON_LATITUDE_RATIO))
            let annotationImageViewRect = CGRect(x: dimension / -2, y: dimension / -2, width: dimension, height: dimension)
            let annotationImageView = UIImageView(frame: annotationImageViewRect)
            annotationImageView.contentMode = UIViewContentMode.scaleAspectFit
            annotationImageView.image = stateImages[TOWER_STATE_IDLE]
            annotationImageViews.append(annotationImageView)
            annotationView.addSubview(annotationImageView)
            return annotationView
        } else {
            return nil
        }
    }
    
    // MARK: - Outlet Functions
    
    // ----------------------------------------------------------------
    // mapWasPinched - triggered when user zooms in or out on map,
    //                 resizes annotation icon image views accordingly
    // ----------------------------------------------------------------

    @IBAction func mapWasPinched(_ sender: Any) {
        print("yes!")
        let dimension = min(ICON_SIZE_MAXIMUM, max(ICON_SIZE_MINIMUM, satelliteMapView.region.span.latitudeDelta / ICON_LATITUDE_RATIO))
        print(dimension)
        let newAnnotationImageViewRect = CGRect(x: dimension / -2, y: dimension / -2, width: dimension, height: dimension)
        for annotationImageView in annotationImageViews {
            annotationImageView.frame = newAnnotationImageViewRect
        }
    }
    
    // MARK: - Class Functions
    
    // ----------------------------------------------------------------
    // recieveFirebaseData - recieve Firebase data
    // ----------------------------------------------------------------
    
    func recieveFirebaseData(_ data: DataSnapshot) -> Void {
        print (data.valueInExportFormat() ?? "not...found")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
