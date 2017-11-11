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
        
        startLocationUpdates()
        
        basicEvents?.delegateRotate = self
        basicEvents?.delegateMapIsInactive = self
        
        routeButtonsView.ptpDelegate = self
        
        map.setMapEventListener(basicEvents)
        
        routeController.locationMarker = self.locationMarker
        
        routeButtonsView.setUpView(routeController: routeController, basicEvents: basicEvents, map: map)
    }
}

extension MapViewController: RotationDelegate {
    
    func rotated(angle: CGFloat) {
        if (self.isRotationInProgress) {
            // Do not rotate when rotation reset animation is in progress
            return
        }
        self.rotationResetButton.rotate(angle: angle)
    }
    
    func zoomed(zoom: CGFloat) {
        
    }
}

