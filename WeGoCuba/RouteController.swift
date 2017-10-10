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
    
    var routing: Routing!
    var mapListener: RouteMapEventListener!
    var actualEventsSave : NTMapEventListener!
    var progressLabel : ProgressLabel!
    
    init(mapView : NTMapView, progressLabel : ProgressLabel) {
        
        self.map = mapView
        self.progressLabel = progressLabel
        
        mapListener = RouteMapEventListener()
    }
    
    func startRoute() {
        actualEventsSave = map.getMapEventListener()
        
        mapListener.delegate = self
        map.setMapEventListener(mapListener)
        routing = Routing(mapView: self.map)
    }
    
    func finishRoute(){
        routing.cleaning()
        mapListener.delegate = nil
        map.setMapEventListener(nil)
        map.setMapEventListener(actualEventsSave)
    }
    
    func singleTap() {
        // No actions for single tap
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
}
