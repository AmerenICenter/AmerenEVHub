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
let AMEREN_HQ_LATITUDE: CLLocationDegrees = 38.62305
let AMEREN_HQ_LONGITUDE: CLLocationDegrees = -90.2116
let AMEREN_HQ_LATITUDE_SPAN: CLLocationDegrees = 0.006488 / 4
let AMEREN_HQ_LONGITUDE_SPAN: CLLocationDegrees = 0.010014 / 4

// Icon size as a proportion of latitude range
let ICON_LATITUDE_RATIO: Double = 0.02

// Icon size minimum and maximum
let ICON_SIZE_MINIMUM: Double = 5
let ICON_SIZE_MAXIMUM: Double = 15

// EV tower state codes
let TOWER_STATE_IDLE = 1
let TOWER_STATE_CONNECTED = 4
let TOWER_STATE_CHARGING = 5
let TOWER_STATE_FAULT = 6

// Dictionary mapping parking spot states to UIImage objects
var stateImages: [Int : UIImage] = [TOWER_STATE_IDLE : #imageLiteral(resourceName: "Free Symbol"), TOWER_STATE_CONNECTED : #imageLiteral(resourceName: "Complete Symbol"), TOWER_STATE_CHARGING : #imageLiteral(resourceName: "Charging Symbol"), TOWER_STATE_FAULT : #imageLiteral(resourceName: "Error Symbol")]

class ParkingSatelliteViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlet Connections

    // Map subview
    @IBOutlet weak var satelliteMapView: MKMapView!
    
    // MARK: - Class Variables
    
    // Default map center, span, and region
    var defaultCenter: CLLocationCoordinate2D! = nil
    var defaultSpan: MKCoordinateSpan! = nil
    var defaultRegion: MKCoordinateRegion! = nil
    
    // Parking spot index JSON object
    var spotLocations = [String : [CLLocationDegrees]]()
    
    // Annotation image view array
    var annotationImageViews = [UIImageView]()
    
    // Firebase database reference
    var parkingDatabaseRef: FIRDatabaseReference!
    
    // Spot data snapshot (updated with current state)
    var spotData: FIRDataSnapshot?
    
    // MARK: - Overridden UIViewController Functions
    
    // ----------------------------------------------------------------
    // viewDidLoad - called whenever view controller's view is loaded
    //               on-screen; sets map scope
    // ----------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Define center, span, and range
        defaultCenter = CLLocationCoordinate2D(latitude: AMEREN_HQ_LATITUDE, longitude: AMEREN_HQ_LONGITUDE)
        defaultSpan = MKCoordinateSpan(latitudeDelta: AMEREN_HQ_LATITUDE_SPAN, longitudeDelta: AMEREN_HQ_LONGITUDE_SPAN)
        defaultRegion = MKCoordinateRegion(center: defaultCenter, span: defaultSpan)
        
        // Set map type to satellite and set region
        satelliteMapView.mapType = MKMapType.hybrid
        satelliteMapView.setRegion(defaultRegion, animated: false)
        
        // Opens annotation JSON file
        do {
            let parkingLotJSONPath = Bundle.main.path(forResource: PARKING_LOT_JSON_FILENAME, ofType: "json")
            let parkingLotJSONText = try String(contentsOfFile: parkingLotJSONPath!)
            print(parkingLotJSONText)
            spotLocations = try JSONSerialization.jsonObject(with: parkingLotJSONText.data(using: String.Encoding.unicode)!, options:[]) as! [String : [CLLocationDegrees]]
        } catch {
            print (error)
        }

        // Queries database for tower states
        parkingDatabaseRef = FIRDatabase.database().reference()
        parkingDatabaseRef.child("EVApp/EVAppData").observe(FIRDataEventType.value, with: recieveFirebaseData)
        
        refreshAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MKMapViewDelegate Functions
    
    // ----------------------------------------------------------------
    // mapView:regionWillChangeAnimated: - called right after map view
    //                                     changes, resizes annotation
    //                                     views (kinda choppy, but
    //                                     what're you gonna do)
    // @param mapView - the current MKMapView
    // @param regionDidChangeAnimated - if the change is gonna be
    //                                  animated, which I'm not sure
    //                                  what I want to do with
    // ----------------------------------------------------------------

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let dimension = min(ICON_SIZE_MAXIMUM, max(ICON_SIZE_MINIMUM, ICON_LATITUDE_RATIO / mapView.region.span.latitudeDelta))
        let newAnnotationImageViewRect = CGRect(x: dimension / -2, y: dimension / -2, width: dimension, height: dimension)
        for annotationImageView in annotationImageViews {
            annotationImageView.frame = newAnnotationImageViewRect
        }
    }
    
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
            let dimension = min(ICON_SIZE_MAXIMUM, max(ICON_SIZE_MINIMUM, ICON_LATITUDE_RATIO / satelliteMapView.region.span.latitudeDelta))
            let annotationImageViewRect = CGRect(x: dimension / -2, y: dimension / -2, width: dimension, height: dimension)
            let annotationImageView = UIImageView(frame: annotationImageViewRect)
            annotationImageView.contentMode = UIViewContentMode.scaleAspectFit
            if let sd = spotData {
                let spotTitle: String = "parkingSpot" + String(spotAnnotation.spotID) + "/EVSEState"
                let spotState: Int = sd.childSnapshot(forPath: spotTitle).value as! Int
                annotationImageView.image = stateImages[spotState]
                spotAnnotation.addDetailView(annotationView, towerState: spotState)
            } else {
                annotationImageView.image = stateImages[TOWER_STATE_FAULT]
                spotAnnotation.addDetailView(annotationView, towerState: TOWER_STATE_FAULT)
            }
            annotationImageViews.append(annotationImageView)
            annotationView.addSubview(annotationImageView)
            return annotationView
        } else {
            return nil
        }
    }
    
    // MARK: - Class Functions
    
    // ----------------------------------------------------------------
    // recieveFirebaseData - recieve Firebase data
    // ----------------------------------------------------------------
    
    func recieveFirebaseData(_ data: FIRDataSnapshot) -> Void {
        print("Data recieved")
        spotData = data
        refreshAnnotations()
    }
    
    // ----------------------------------------------------------------
    // refreshAnnotations - resets map view's annotation array with
    //                      current parking space data
    // ----------------------------------------------------------------
    
    func refreshAnnotations() {
        satelliteMapView.removeAnnotations(satelliteMapView.annotations)
        for (idString, coordinates) in spotLocations {
            let id = Int(idString)
            let coordinateObject = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
            let spotAnnotation = ParkingSpotAnnotation(coordinateObject, spotID: id!)
            satelliteMapView.addAnnotation(spotAnnotation)
        }
    }
}
