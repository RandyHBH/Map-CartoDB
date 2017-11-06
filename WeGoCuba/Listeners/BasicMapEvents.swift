//
//  Events.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 9/7/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

public class BasicMapEvents : NTMapEventListener {
    
    var map: NTMapView!
    var stopPosition : NTMapPos!
    
    var navigationMode = false
    
    var previousAngle: CGFloat?
    var previousZoom: CGFloat?
    
    var delegateBasicMapEvents : BasicMapEventsDelgate?
    var delegateRotate: RotationDelegate?
    var delegateMapIsInactive: MapIsInactiveDelegate?
    
    override public func onMapMoved() {
        
        if navigationMode == true {
            delegateMapIsInactive?.resetTimer()
            delegateMapIsInactive?.startTimer()
        }
        
        let angle = CGFloat(map.getRotation())
        let zoom = CGFloat(map.getZoom())
        
        if (previousAngle != angle) {
            delegateRotate?.rotated(angle: angle)
            previousAngle = angle
        } else if (previousZoom != zoom) {
            delegateRotate?.zoomed(zoom: zoom)
            previousZoom = zoom
        }
    }
    
    override public func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        
        if mapClickInfo.getClickType() != .CLICK_TYPE_SINGLE {
            delegateBasicMapEvents?.longTap()
            return
        }
        
        let position = mapClickInfo.getClickPos()
        
        let event = RouteMapEvent()
        
        if (stopPosition == nil) {

            stopPosition = position

            event.clickPosition = position
            event.stopPosition = stopPosition
            
            delegateBasicMapEvents?.stopPositionSet(event: event)
        } else {
            
            stopPosition = nil
            delegateBasicMapEvents?.stopPositionUnSet()
        }
        
    }
}

protocol BasicMapEventsDelgate {
    
    func stopPositionSet(event: RouteMapEvent)
    
    func stopPositionUnSet()
    
    func longTap()
}

protocol RotationDelegate {
    
    func rotated(angle: CGFloat)
    
    func zoomed(zoom: CGFloat)
}

protocol MapIsInactiveDelegate {
    
    func startTimer()
    
    func resetTimer()
}
