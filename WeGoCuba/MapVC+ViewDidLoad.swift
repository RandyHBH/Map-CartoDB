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
        
        map = mapModel.map
        
        manager = CLLocationManager()
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 1
        
        rotationResetButton.resetDuration = rotationDuration
        
        routeController = RouteController(mapView: self.map)
        routeController.locationMarker = self.locationMarker
        
        // TODO: NEED TO OPTIMEZE THIS, MAYBE PUT IT ALL
        // TOGETHER
        
        hideRoutingChoicesView()
        hideRoutePointsSelectionView()
        
        routeButtonsView.hideInfoBar()
        routeButtonsView.hideRouteButton()
        routeButtonsView.hideGoNavigationButton()
        routeButtonsView.hideStopMarkerView()
        
        if #available(iOS 9.0, *) {
            manager.requestAlwaysAuthorization()
        }
    }
}
