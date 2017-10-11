//
//  RouteMapEventListener.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 26/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

/*
 * This MapListener waits for two clicks on map - first to set routing start point, and then second to mark end point and start routing service.
 */
class RouteMapEventListener : NTMapEventListener {
    
    var delegate: RouteMapEventDelegate?
    
    var position, startPosition, endPosition: NTMapPos!
    
    override func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        
        if (mapClickInfo.getClickType() == NTClickType.CLICK_TYPE_LONG) {
            // Only listen to single clicks
            delegate?.longTap()
            return
        }
        
        position = mapClickInfo.getClickPos()
        
        let event = RouteMapEvent()
        
        if (endPosition == nil) {
            endPosition = position
            
            event.clickPosition = position
            event.startPosition = startPosition
            event.stopPosition = endPosition

            delegate?.stopClicked(event: event)
            
        } else {
            startPosition = nil
            endPosition = nil
            delegate?.singleTap()
            
        }
    }
}

protocol RouteMapEventDelegate {
    
    func startClicked(event: RouteMapEvent)
    
    func stopClicked(event: RouteMapEvent)
    
    func singleTap()
    
    func longTap()
}

class RouteMapEvent : NSObject {
    
    var clickPosition: NTMapPos!
    
    var startPosition: NTMapPos!
    
    var stopPosition: NTMapPos!
}





