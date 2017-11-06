//
//  MapVC+ViewDidLoad.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/3/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CoreLocation

extension MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMap()
        
        initLocation()
        
        initMapEventsListener()
        
        rotationResetButton.resetDuration = rotationDuration
        
        progressLabel = ProgressLabel()
        view.addSubview(progressLabel)
        layoutProgressLabel()
        
        routeController = RouteController(mapView: self.map, progressLabel: self.progressLabel)
        
        self.navigationController?.navigationBar.barTintColor = Colors.appBlue
        
    }
    
    private func initMap() {
        
        map = NTMapView()
        
        let cartoTitleOff = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height + 50)
        
        map.frame = cartoTitleOff
        
        map.getOptions().setZoomGestures(true)
        map.getOptions().setZoom(NTMapRange(min: 5, max: 22))
        map.getOptions().setPanningMode(NTPanningMode.PANNING_MODE_STICKY)
        
        //Need to add as a subview
        view.insertSubview(map, at: 1)
        
        // Load MBTiles Vector Tiles
        baseMap = BaseMap(mapView: self.map)
        
        // Get base projection from mapView
        projection = map.getOptions().getBaseProjection()
        
        //Creating GPS Marker
        locationMarker = LocationMarker(mapView: self.map)
        
        // FOCUS IN CUBA
        map?.setFocus(projection?.fromWgs84(NTMapPos(x: -82.2906, y: 23.0469)), durationSeconds: 0)
        map?.setZoom(6, durationSeconds: 3)
    }
    
    private func initLocation() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 1
        
        if #available(iOS 9.0, *) {
            manager.requestAlwaysAuthorization()
        }
    }
    
    private func initMapEventsListener() {
        basicEvents = BasicMapEvents()
        basicEvents.map = map
    }
}
