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
    var progressLabel : ProgressLabel!
    
    init(mapView : NTMapView, progressLabel : ProgressLabel!) {
        super.init()
        
        self.mapView = mapView
        self.progressLabel = progressLabel
        
        client = TurnByTurnClient(mapView: mapView, progressLabel: progressLabel)
    }
    
    func onResume() {
        client.onResume()
    }
    
    
    func onPause() {
        client?.onPause()
    }
}
