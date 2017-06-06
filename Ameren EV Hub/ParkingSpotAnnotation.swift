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
    
    // Integer ID associated with this parking space
    var spotID: Int
    
    // This annotation's view
    weak var view: MKAnnotationView!
    
    // The detail view we create
    @IBOutlet var detailView: UIView!
    
    // MARK: - Class Functions
    
    // ----------------------------------------------------------------
    // init:coord:spotID - initializer, stores latitude and longitude
    //                     of annotation, as well as associated parking
    //                     space ID
    // @param coord - latitude and longitude of parking space
    // @param id - constant space identifier
    // ----------------------------------------------------------------

    init(_ coord: CLLocationCoordinate2D, spotID id: Int) {
        coordinate = coord
        spotID = id
        title = "Spot " + String(spotID)
    }

    // ----------------------------------------------------------------
    // addDetailView - adds hidden detail view to this annotation's 
    //                 view, should be called just about right after
    //                 it's created
    // @param view - the view associated with this annotation
    //               (retained)
    // ----------------------------------------------------------------
    
    func addDetailView(_ aView: MKAnnotationView) {
        self.view = aView
        Bundle.main.loadNibNamed("ParkingSpotAnnotationDetailView", owner: self, options: nil)
        self.detailView.frame.size.height = 90
        self.detailView.frame.size.width = 50
        self.view.canShowCallout = true
        self.view.detailCalloutAccessoryView = self.detailView
        
    }
    
    // ----------------------------------------------------------------
    // showDetail - shows space's detail view
    // ----------------------------------------------------------------

    func showDetail() {
        
    }
    
    // ----------------------------------------------------------------
    // hideDetail - hides space's detail view
    // ----------------------------------------------------------------

    func hideDetail() {
        
    }
}
