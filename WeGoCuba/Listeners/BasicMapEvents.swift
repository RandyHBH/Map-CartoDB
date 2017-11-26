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
    var position, startPosition, stopPosition: NTMapPos!

    var previousAngle: CGFloat?
    var previousZoom: CGFloat?
    
    var delegate: RouteMapEventDelegate?
    var delegateRotate: RotationDelegate?
    
    var delegateMapIsInactive: MapIsInactiveDelegate?
    
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
        
        if DataContainer.instance.latestLocation != nil {
            delegate?.hideLocationButton()
        }
        
        if stopPosition != nil {
            delegate?.showStopMarkerPosition()
        }
    }
    
    override public func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        
        if mapClickInfo.getClickType() != .CLICK_TYPE_SINGLE {
            delegate?.longTap()
            return
        }
        
        position = mapClickInfo.getClickPos()
        
        switch AppState.instance.routeState {
            
        case .ROUTE_FROM_ONE_POINT:
            switch AppState.instance.mapState {
                
            case .WAITING_FOR_END_CLICK:
                sendStopPosition(position: position)
                
            case .WAITING_FOR_CLICK:
                // CLEAN MARKER BACAUSE IS THE DEFAULT FUNCTIONALITY IN ONE_POINT ROUTE
                delegate?.cleanMarkers()
                cleaningLeftOvers()
                AppState.instance.mapState = .WAITING_FOR_END_CLICK
                //TODO: WHEN VECTOR ELEMENTS EXIST HERE GOES THE SELECT LOGIC
                
            default:
                break
            }
            
        case .ROUTE_FROM_TWO_POINT:
            switch AppState.instance.mapState {
                
            case .WAITING_FOR_START_CLICK:
                sendStartPosition(position: position)
                
            case .WAITING_FOR_END_CLICK:
                sendStopPosition(position: position)
                
            case .WAITING_FOR_CLICK where startPosition != nil && stopPosition != nil:
                delegate?.cleanMarkers()
                cleaningLeftOvers()
                AppState.instance.mapState = .WAITING_FOR_END_CLICK
                
            case .WAITING_FOR_CLICK where startPosition != nil:
                //TODO: WHEN VECTOR ELEMENTS EXIST AND ONE IS SELECTED THE SELECT LOGIC GOES HERE
                sendStopPosition(position: position)
                
            case .WAITING_FOR_CLICK where startPosition == nil:
                //TODO: WHEN VECTOR ELEMENTS EXIST AND ONE IS SELECTED THE SELECT LOGIC GOES HERE
                delegate?.cleanMarkers()
                cleaningLeftOvers()
                AppState.instance.mapState = .WAITING_FOR_END_CLICK
 
            default:
                //TODO: WHEN VECTOR ELEMENTS EXIST HERE GOES THE SELECT LOGIC
                return
            }
            
        case .CALCULATING_ROUTE:
            // DONT DO NOTHING WHIT MARKERS IN MAP UNTIL CALCULATIONS ARE FINISHED
            //TODO: WHEN VECTOR ELEMENTS EXIST THE SELECT LOGIC GOES HERE
            return
            
            // WHIT THE ROUTE CALCULATE YOU CAN CHANGE THE FINAL POSITION
        case .ROUTE_CALCULATED:
            sendStopPosition(position: position)
            
        // THIS IS THE STARTING STATE OF THE APP
        case .CLEAN_ROUTE:
            switch AppState.instance.mapState {
                
            case .WAITING_FOR_END_CLICK:
                sendStopPosition(position: position)
                // CHANGE THE ROUTE STATE
                AppState.instance.routeState = .ROUTE_FROM_ONE_POINT
                
            // GO HERE AFTER CLACULATE A ROUTE AND THEN CLEANING
            case .WAITING_FOR_CLICK:
                sendStopPosition(position: position)
                // CHANGE THE ROUTE STATE
                AppState.instance.routeState = .ROUTE_FROM_ONE_POINT
            default:
                break
            }
        }
    }
    
    func sendStopPosition(position: NTMapPos) {
        
        // NEED TO SAVE MARKERS POSITION FOR LATER USE IN CALCULATIONS OF ROUTING
        let event = RouteMapEvent()
        stopPosition = position
        event.stopPosition = stopPosition
        
        delegate?.stopClicked(event: event)
        AppState.instance.mapState = .WAITING_FOR_CLICK
    }
    
    func sendStartPosition(position: NTMapPos) {
        
        // NEED TO SAVE MARKERS POSITION FOR LATER USE IN CALCULATIONS OF ROUTING
        let event = RouteMapEvent()
        startPosition = position
        event.startPosition = startPosition
        
        delegate?.startClicked(event: event)
        AppState.instance.mapState = .WAITING_FOR_END_CLICK
    }
    
    func cleaningLeftOvers() {
        startPosition = nil
        stopPosition = nil
    }
}

protocol RouteMapEventDelegate {
    
    func startClicked(event: RouteMapEvent)
    
    func stopClicked(event: RouteMapEvent)
    
    func cleanMarkers()
    
    func longTap()
    
    func hideLocationButton()
    
    func showStopMarkerPosition()
}

class RouteMapEvent : NSObject {
    
    var startPosition: NTMapPos!
    
    var stopPosition: NTMapPos!
}

protocol RotationDelegate {
    
    func rotated(angle: CGFloat)
    
    func zoomed(zoom: CGFloat)
}

protocol MapIsInactiveDelegate {
    
    func startTimer()
    
    func resetTimer()
}
