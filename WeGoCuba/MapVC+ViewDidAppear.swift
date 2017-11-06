//
//  MapVC+ViewDidAppear.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/3/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

extension MapViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // START UPDATING LOCATION, WHEN STOP THE UPDATES????
        startLocationUpdates()
        
        basicEvents?.delegateRotate = self
        basicEvents?.delegateMapIsInactive = self
        
        map.setMapEventListener(basicEvents)
        
        self.routeController.locationMarker = self.locationMarker
        
        self.routeButtonsView.setUpView(routeController: routeController, basicEvents: basicEvents, map: map, marker: locationMarker)
    }
}
