//
//  ParkingSpotAnnotation.swift
//  Ameren EV Hub
//
//  Created by Rick Lewis on 5/26/17.
//  Copyright © 2017 Ameren. All rights reserved.
//

import UIKit
import MapKit

class ParkingSpotAnnotation: NSObject, MKAnnotation {
    
    // MARK: - MKAnnotation Protocol Attributes
    
    // Annotation's location
    var coordinate: CLLocationCoordinate2D
    
    // Annotation's title and subtitle
    var title: String?
    var subtitle: String?
    
    // MARK: - Class Variables
    
    var spotID: Int
    
    init(_ coord: CLLocationCoordinate2D, spotID id: Int) {
        coordinate = coord
        spotID = id
        title = "Spot " + String(spotID)
    }
}
