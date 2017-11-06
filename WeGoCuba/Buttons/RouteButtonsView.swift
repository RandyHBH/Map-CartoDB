//
//  RoutePTPView.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/3/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit

class RouteButtonsView: UIView, BasicMapEventsDelgate {
    
    @IBOutlet weak var ptpContainer: UIView!
    @IBOutlet weak var ptpButton: UIButton!
    
    @IBOutlet weak var routeContainer: UIView!
    @IBOutlet weak var routeButton: UIButton!
    
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var active = false
    
    var map: NTMapView!
    
    var routeController: RouteController?
    var basicEvents: BasicMapEvents?
    var locationMarker: LocationMarker?
    var latestLocation: CLLocation!
    
    var ptpDelegate: PTPButtonDelegate?
    var routeDelegate: RouteButtonDelegate?
    
    override func awakeFromNib() {
        
    }
    
    @IBAction func ptpButtonTapped (_ sender: UIButton) {
        self.routeController?.startRoute()
        ptpDelegate?.ptpButtonTapped()
    }
    
    @IBAction func routeButtonTapped (_ sender: UIButton) {
        
        if  basicEvents?.stopPosition != nil {
            
            let latitude = Double(latestLocation.coordinate.latitude)
            let longitude = Double(latestLocation.coordinate.longitude)
            
            let startPosition = locationMarker?.projection.fromWgs84(NTMapPos(x: longitude, y: latitude))
            
            let stopPosition = basicEvents?.stopPosition
            
            self.routeController?.showRoute(start: startPosition!, stop: stopPosition!)
            
            basicEvents?.navigationMode = true
            self.locationMarker?.modeNavigation()
            
        } else {
            
            stopPositionUnSet()
            
        }
        routeDelegate?.routeButtonTapped()
    }
    
    @IBAction func locationButtonTapped (_ sender: UIButton) {
        if (latestLocation != nil) {
            
            let latitude = Double(latestLocation.coordinate.latitude)
            let longitude = Double(latestLocation.coordinate.longitude)
            
            let position = locationMarker?.projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
            
            map.setZoom(18, durationSeconds: 2)
            map.setFocus(position, durationSeconds: 1)
        }
    }
    
    func setUpView(routeController: RouteController, basicEvents: BasicMapEvents, map: NTMapView, marker: LocationMarker) -> Void {
        
        self.map = map
        self.locationMarker = marker
        self.routeController = routeController
        self.basicEvents = basicEvents
        self.basicEvents?.delegateBasicMapEvents = self
        
    }

    // MARK: BASIC MAP EVENTS DELEGATE
    
    func stopPositionSet(event: RouteMapEvent) {
        self.routeController?.onePointRoute(event: event)
        showHideRouteButton()
    }
    
    func stopPositionUnSet() {
        self.basicEvents?.stopPosition = nil
        self.routeController?.finishRoute()
        self.locationMarker?.modeFree()
        showHideRouteButton()
    }
    
    func longTap(){
        // NO RESPONDER A LOS LONG-TAPS
    }
    
    fileprivate func showHideRouteButton() {
        active = !active
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.heightConstraint.constant =  self.active ? 50 : 0
            })
        }
    }
    
}

protocol PTPButtonDelegate {
    func ptpButtonTapped()
}

protocol RouteButtonDelegate {
    func routeButtonTapped()
}

protocol LocationButtonDelegate {
    func locationButtonTapped()
}
