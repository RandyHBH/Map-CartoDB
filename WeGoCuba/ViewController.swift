//
//  ViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 8/29/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit



class ViewController: GLKViewController {
    
    var mapView: NTMapView!
    
    let appTitle = "WeGoCuba"
    
    var source: NTLocalVectorDataSource?
    var projection: NTProjection?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initialazing()
    
        setBaseLayer(projection: projection!, source: source!)
        
        setInitialLocation(projection: projection!)
        
        setTitle(atitle: appTitle)
        
        let marker = mapView.emptyPositionMarker(projection: self.projection!)
        
        let listener = Events(marker: marker);
        
        mapView?.setMapEventListener(listener);
        
    }
    
    func initialazing() {
        
        //Initialization map
        self.mapView = NTMapView()
        self.mapView = (self.view as! NTMapView)
        
        // Get base projection from mapView
        self.projection = mapView?.getOptions().getBaseProjection();
        
        // Create a local vector data source
        self.source = NTLocalVectorDataSource(projection: projection);
    }
    
    func setBaseLayer(projection: NTProjection, source: NTVectorDataSource) {
        
        // Initialize layer
        let layer = NTVectorLayer(dataSource: source)
        // Add layer
        self.mapView.getLayers().add(layer)
        
    }
    
    func setInitialLocation(projection: NTProjection) {
        
        let tallinn = projection.fromWgs84(NTMapPos(x: 19.2533, y: -79.426939));
        
        self.mapView.setFocus(tallinn, durationSeconds: 0)
        self.mapView.setZoom(14, durationSeconds: 2)
    }
    
    func setTitle(atitle: String) {
        // App Title
        title = atitle
    }
    
    
}

