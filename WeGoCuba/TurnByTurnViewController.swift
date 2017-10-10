//
//  TurnByTurnViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/9/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CoreLocation

class TurnByTurnViewController: NSObject {
    
    var mapView : NTMapView!
    var client : TurnByTurnClient!
    
    init(mapView : NTMapView) {
        super.init()
        
        self.mapView = mapView
        
        client = TurnByTurnClient(mapView: mapView)
    }
    
    func onResume() {
        client.onResume()
    }
    
    
    func onPause() {
        client?.onPause()
    }
}
