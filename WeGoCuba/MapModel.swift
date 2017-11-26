//
//  ModelController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/19/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

class MapModelController {
    
    var map: NTMapView!
    var projection: NTProjection!
    var locationMarker: LocationMarker!
    
    var baseMap: BaseMap!
    
    init() {
        
        map = NTMapView()
        map.getOptions().setZoomGestures(true)
        map.getOptions().setZoom(NTMapRange(min: 5, max: 22))
        map.getOptions().setPanningMode(NTPanningMode.PANNING_MODE_STICKY)
        
        // Load MBTiles Vector Tiles
        baseMap = BaseMap(mapView: self.map)
        
        // Get base projection from mapView
        projection = map.getOptions().getBaseProjection()
        
        //Creating GPS Marker
        locationMarker = LocationMarker(mapView: self.map)
    }
}
