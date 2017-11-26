//
//  NavigationViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/13/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class NavigationViewController: UIViewController, NextTurnDelegate {

    var map: NTMapView!
    @IBOutlet weak var mapContainer: UIView!
    
    var client: NavigationClient!
    var locationMarker: LocationMarker!
    var routeController: RouteController!
    
    var routeInfo: Route!
    
    @IBOutlet weak var navBar: NavigationNavBar!
    @IBOutlet weak var hideNavBarButton: UIButton!
    
    @IBOutlet weak var banner: NavigationBanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Need to add as a subview
        mapContainer.addSubview(map)
        
        
        routeController.locationMarker = locationMarker
        
        client = NavigationClient(map: map, marker: locationMarker)
        client.routeController = routeController
        
        navBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        client.startLocationUpdates()
        client.startNavigationMode()
        
        navBar.updateInfo(info: routeInfo)
        navBar.updateProgressBar(progress: 0.0)
        
        routeController.delegate = self
//        basicEvents?.delegateMapIsInactive = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        client.stopLocationUpdates()
        client.stopNavigationMode()
        navBar.delegate = nil
        locationMarker.isNavigationMode = false
        locationMarker.navigationModeFirstTime = true
        routeController.finishRoute()
    }
    
    // MARK: ROTATION FIX FOR MAP DISPLAYING BAD IN LANDSCAPE
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let cartoTitleOff = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 50)
        map.frame = cartoTitleOff
    }
    
    // MARK: CLASS INSTANCE
    class func newInstance() -> NavigationViewController? {
        let mapNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationViewController") as! NavigationViewController
        return mapNVC
    }
    
    let mapMoveDuration: Float = 3
    
    func instructionFound(current: Instruction, next: Instruction?) {
        banner.updateInstruction(current: current, next: next)
    }
    
    func routingFailed(info: String) {
        
    }
    
    func locationUpdated(result: NTRoutingResult) {
        
    }
}

extension NavigationViewController: NavigationNavBarDelegate {
    
    func endNavigationButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func showRouteButtonTapped() {
        
        client.isInNavigationMode = false
        // User interaction is disabled in navigation mode
        map.isUserInteractionEnabled = true
        
        let bounds = routeInfo.bounds

        self.map.move(toFit: bounds, screenBounds: self.findScreenBounds(), integerZoom: false, resetRotation: false, resetTilt: true, durationSeconds: 0)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(self.onRotationCompleted), userInfo: nil, repeats: false)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(self.returnToNavigationMode), userInfo: nil, repeats: false)
        
    }
    
    func returnToNavigationMode() {
        client.startNavigationMode()
    }
    
    func onRotationCompleted() {
        let bearing = -Float(routeInfo.bearing)
        map.setRotation(bearing, targetPos: routeInfo.bounds?.getCenter(), durationSeconds: mapMoveDuration - 1)
        self.map.setFocus(locationMarker.navigationPointer.getBounds().getCenter(), durationSeconds: self.mapMoveDuration)
    }
    
    func findScreenBounds() -> NTScreenBounds {
        let screenWidth: Float = Float((map.frame.size.width))
        let screenHeight: Float = Float((map.frame.size.height))
        let minScreenPos: NTScreenPos = NTScreenPos(x: 0.0, y: 0.0)
        let maxScreenPos: NTScreenPos = NTScreenPos(x: screenWidth, y:screenHeight)
        return NTScreenBounds(min: minScreenPos, max: maxScreenPos)
    }
}
