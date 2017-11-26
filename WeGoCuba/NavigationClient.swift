//
//  NavigationClient.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/19/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation
import CoreLocation

class NavigationClient: NSObject, CLLocationManagerDelegate {
    
    var map: NTMapView!
    var locationMarker: LocationMarker!
    
    let manager = CLLocationManager()
    
    var routeController: RouteController!
    
    init(map: NTMapView, marker: LocationMarker) {
        
        self.map = map
        self.locationMarker = marker
        self.locationMarker.isNavigationMode = true
        
        if #available(iOS 9.0, *) {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: CORE LOCATION METHODS
    func startLocationUpdates() {
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        self.manager.startUpdatingHeading()
    }
    
    func stopLocationUpdates() {
        self.manager.delegate = nil
        self.manager.stopUpdatingLocation()
        self.manager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let latestLocation = DataContainer.instance.latestLocation
        
        if (latestLocation != nil) {
            if (latestLocation!.coordinate.latitude == location.coordinate.latitude) {
                if (latestLocation!.coordinate.longitude == location.coordinate.longitude) {
                    
                    return
                }
            }
        }
        
        DataContainer.instance.latestLocation = location
        
        self.routeController.updateRoute(location: location)

    }
    
    /*
     * Navigation mode with 60% tilt and 18 zoom,
     * MapView user interaction is also disabled
     */
    var isInNavigationMode = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if (newHeading.headingAccuracy < 0) {
            // Ignore if there's no accuracy, no point in processing it
            return
        }
        
        // Use true heading if it is valid.
        let heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading)
        
        if (isInNavigationMode) {
            let angle = -Float(heading)
            map.setRotation(angle, durationSeconds: 0)
            zoomAndTiltToPosition(duration: 0)
        }
    }
    
    let navigationTilt: Float = 30
    let navigationZoom: Float = 18
    
    func zoomAndTiltToPosition(duration: Float) {
        
        if (map.getTilt() != navigationTilt) {
            map.setTilt(navigationTilt, durationSeconds: duration)
            map.setZoom(navigationZoom, durationSeconds: duration)
            
            let angle = locationMarker.navigationPointer.getRotation()
            map.setRotation(angle, durationSeconds: duration)
            locationMarker.rotate(rotation: 0)
            
        }
        
        let position = locationMarker.navigationPointer.getBounds().getCenter()
        map.setFocus(position, durationSeconds: duration)
        
    }
    
    func startNavigationMode() {
        
        isInNavigationMode = true
        // User interaction is disabled in navigation mode
        map.isUserInteractionEnabled = false
        
        let duration: Float = 0.5
        zoomAndTiltToPosition(duration: duration)
    }
    
    func stopNavigationMode() {
        
        isInNavigationMode = false
        // User interaction is disabled in navigation mode
        map.isUserInteractionEnabled = true
        
        let duration: Float = 0.5
        
        map.setTilt(90, durationSeconds: duration)
        map.setRotation(0, durationSeconds: duration)
    }
}

