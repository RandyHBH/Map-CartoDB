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
    
    var mapView : NTMapView!
    var marker : LocationMarker!
    var latest : CLLocation!
    var routing : Routing!
    
    let destinationListener = DestinationClickListener()
    
    init(mapView : NTMapView, progressLabel: ProgressLabel) {
        super.init()
        
        self.mapView = mapView
        
        marker = LocationMarker(mapView: self.mapView)
        
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 1
        
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
