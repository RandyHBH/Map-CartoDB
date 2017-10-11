//
//  Events.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 9/7/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

public class BasicMapEvents : NTMapEventListener
{
    var map: NTMapView!
    
    var previousAngle: CGFloat?
    var previousZoom: CGFloat?
    
    var delegateBasicMapEvents : BasicMapEventsDelgate?
    var delegateRotate: RotationDelegate?
    
    override public func onMapMoved() {
        
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
        
        switch mapClickInfo.getClickType() {
            
        case .CLICK_TYPE_LONG:
            delegateBasicMapEvents?.longTap()
            
        default:
            let position = mapClickInfo.getClickPos()
            
            let event = RouteMapEvent()
            
            event.clickPosition = position
            
            delegateBasicMapEvents?.startClicked(event: event)
            
        }
    }
}

protocol BasicMapEventsDelgate {
    
    func startClicked(event: RouteMapEvent)
    
    func longTap()
}

protocol RotationDelegate {
    
    func rotated(angle: CGFloat)
    
    func zoomed(zoom: CGFloat)
}
