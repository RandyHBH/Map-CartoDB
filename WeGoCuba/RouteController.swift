//
//  RouteController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/9/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

class RouteController: NSObject, RouteMapEventDelegate {
    
    var map : NTMapView!
    var hopper: GraphHopper!
    var routing: Routing!
    var mapListener: RouteMapEventListener!
    var actualEventsSave : NTMapEventListener!
    var progressLabel : ProgressLabel!
    
    init(mapView : NTMapView, progressLabel : ProgressLabel) {
        super.init()
        
        self.map = mapView
        self.progressLabel = progressLabel
        
        initGraphhoper()
        
        mapListener = RouteMapEventListener()
        routing = Routing(mapView: self.map, hopper: self.hopper)
    }
    
    func onePointRoute(event: RouteMapEvent) {
        
        routing.setStopMarker(position: event.clickPosition)
    }
    
    func startRoute() {
        map.setMapEventListener(mapListener)
        mapListener.delegate = self
        routing = Routing(mapView: self.map, hopper: self.hopper)
    }
    
    func finishRoute(){
        routing.cleaning()
    }
    
    func singleTap() {
        finishRoute()
        mapListener.delegate = nil
        map.setMapEventListener(nil)
        map.setMapEventListener(actualEventsSave)
    }
    
    func longTap() {
        // No action for long tap
    }
    
    func startClicked(event: RouteMapEvent) {
        DispatchQueue.main.async(execute: {
            self.routing.setStartMarker(position: event.clickPosition)
            self.progressLabel.hide()
        })
    }
    
    func stopClicked(event: RouteMapEvent) {
        routing.setStopMarker(position: event.clickPosition)
        showRoute(start: event.startPosition, stop: event.stopPosition)
    }
    
    
    func showRoute(start: NTMapPos, stop: NTMapPos) {
        DispatchQueue.global().async {
            
            let result: GHResponse? = self.routing.getResult(startPos: start, stopPos: stop)
            
            DispatchQueue.main.async(execute: {
                if (result == nil) {
                    self.progressLabel.complete(message: "Routing failed. Please try again")
                    return
                } else {
                    self.progressLabel.complete(message: self.routing.getMessage(result: result!))
                }
                
                let color = NTColor(r: 14, g: 122, b: 254, a: 150)
                self.routing.show(result: result!, lineColor: color!, complete: {
                    (route: Route) in
                    
                })
            })
        }
    }
    
    func initGraphhoper(){
        let location: String? = Bundle.main.path(forResource: "graph-data", ofType: "osm-gh")
        self.hopper = GraphHopper()
        self.hopper!.setCHEnabledWithBoolean(true)
        self.hopper!.setEnableInstructionsWithBoolean(true)
        self.hopper!.setAllowWritesWithBoolean(false)
        self.hopper!.setEncodingManagerWith(EncodingManager.init(nsString: "car"))
        self.hopper!.forMobile()
        self.hopper!.load__(with: location)
        print(self.hopper!.getStorage().getBounds())
        
    }
}
