//
//  TurnbyTurnClient.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/9/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation
import CoreLocation

class TurnByTurnClient: NSObject, CLLocationManagerDelegate {
    
    let manager : CLLocationManager = CLLocationManager()
    
    var map : NTMapView!
    var marker : LocationMarker!
    var latest : CLLocation!
    var routingController : RouteController!
    var progressLabel : ProgressLabel!
    
    let destinationListener = DestinationClickListener()
    
    init(mapView : NTMapView, progressLabel : ProgressLabel!) {
        super.init()
        
        self.map = mapView
        self.progressLabel = progressLabel
        
        marker = LocationMarker(mapView: self.map)
        routingController = RouteController(mapView: self.map, progressLabel: progressLabel)
        
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 1
        
        /*
         * In addition to requesting background location updates, you need to add the following lines to your Info.plist:
         *
         * 1. Privacy - Location When In Use Usage Description
         * 2. Required background modes:
         *    2.1 App registers for location updates
         *
         * In most realistic scenarios, you'd also require:
         * Privacy - Location Always Usage Description
         * and need to call call manager.requestAlwaysAuthorization(),
         * but we're not doing this here, as it's a sample applocation
         */
        
        if #available(iOS 9.0, *) {
            manager.requestWhenInUseAuthorization()
        }
        
    }
    
    func onResume() {
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func onPause() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        manager.delegate = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        if (latest.coordinate.latitude == location.coordinate.latitude) {
            if (latest.coordinate.longitude == location.coordinate.longitude) {
                return
            }
        }
        
        latest = location
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("Updated Coordinates: " + String(describing: latitude) + ", " + String(describing: longitude))
        
        marker.showUserAt(location: location)
        
        // Zoom & focus is enabled by default, disable after initial location is set
        marker.focus = false
        
        let destination = destinationListener?.destination
        
        if (destination != nil) {
            let position = marker.projection.fromLat(latitude, lng: longitude)
            
            routingController.showRoute(start: position!, stop: destination!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if (newHeading.headingAccuracy < 0) {
            // Ignore if there's no accuracy, no point in processing it
            return
        }
        
        // Use true heading if it is valid.
        let heading = (newHeading.headingAccuracy > 0) ? newHeading.trueHeading : newHeading.magneticHeading
        
        print("Updated Heading: " + String(describing: heading)) 
        
    }
    
}
