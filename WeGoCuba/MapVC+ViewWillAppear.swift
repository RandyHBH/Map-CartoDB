//
//  MapVC+ViewDidAppear.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/3/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation
import CoreLocation

extension MapViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initMap()
        
        initLocation()
        
        startLocationUpdates()
        
        initMapEventsListener()
        
        routeButtonsView.ptpDelegate = self
        routeButtonsView.goDelegate = self
        
        map.setMapEventListener(basicEvents)

        setupStatusBarColor()
        
        routeButtonsView.setUpView(routeController: routeController, basicEvents: basicEvents, map: map)
    }
    
    private func initMap() {
        
        map = mapModel.map
        
        let cartoTitleOff = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height + 50)
        
        map.frame = cartoTitleOff
        
        //Need to add as a subview
        mapContainer.addSubview(map)
        
        //Creating GPS Marker
        locationMarker = mapModel.locationMarker
        
        // FOCUS IN CUBA THIS CAN BE CHANGED TO FOCUS TO USER MARKER POS
        map?.setFocus(mapModel.projection.fromWgs84(NTMapPos(x: -82.2906, y: 23.0469)), durationSeconds: 0)
        map?.setZoom(10, durationSeconds: 3)
    }
    
    private func initLocation() {
        manager.delegate = self
    }
    
    private func initMapEventsListener() {
        basicEvents = BasicMapEvents()
        basicEvents.map = map
        basicEvents?.delegateRotate = self
    }
}

extension MapViewController {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let statusBarView = self.navigationController?.view.viewWithTag(100)
        statusBarView?.removeFromSuperview()

        stopLocationUpdates()
        manager.delegate = nil
        
        basicEvents?.delegateRotate = nil
        basicEvents?.delegateMapIsInactive = nil
        
        map.setMapEventListener(nil)
        
        routeButtonsView.cleaning()
    }
}
