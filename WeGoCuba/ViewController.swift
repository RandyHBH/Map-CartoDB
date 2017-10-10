//
//  ViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 8/29/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, RotationDelegate, LocationButtonDelegate,RouteButtonDelegate {
    
    @IBOutlet var map: NTMapView!
    @IBOutlet var locationButton: LocationButton!
    @IBOutlet var routeButton: RouteButton!
    @IBOutlet var scaleBar: ScaleBar!
    @IBOutlet var rotationResetButton: RotationResetButton!
    
    
    // BASIC MAP DECLARATION
    var projection: NTProjection!
    var baseMap : BaseMap!
    
    // LOCATIONS MARKERS
    var locationMarker : LocationMarker!
    
    // BASIC BRUJALA DECLARATION
    var rotationListener: RotationListener!
    
    // BASIC GPS LOCALIZATION DECLARATION
    var manager: CLLocationManager!
    var latestLocation: CLLocation!
    
    // BASIC DECLARATION FOR OFFLINE ROUTE
    var progressLabel: ProgressLabel!
    
    var routeController : RouteController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = NTMapView()
        let cartoTitleOff = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height + 50)
        map.frame = cartoTitleOff
        
        map.getOptions().setZoomGestures(true)
        map.getOptions().setWatermarkBitmap(nil)
        map.getOptions().setPanningMode(NTPanningMode.PANNING_MODE_STICKY)
        
        //Need to add as a subview
        view.insertSubview(map, at: 1)
        
        // Load MBTiles Vector Tiles
        baseMap = BaseMap(mapView: self.map)
        
        // Get base projection from mapView
        projection = map.getOptions().getBaseProjection()
        
        //Creating GPS Marker
        locationMarker = LocationMarker(mapView: self.map)
        
        // FOCUS IN CUBA
        map?.setFocus(projection?.fromWgs84(NTMapPos(x: -82.2906, y: 23.0469)), durationSeconds: 3)
        map?.setZoom(6, durationSeconds: 3)
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 1
        
        /*
         * In addition to requesting background location updates, you need to add the following lines to your Info.plist:
         *
         * 1. Privacy - Location When In Use Usage Description
         * 2. Privacy - Location Always Usage Description
         * 3. Required background modes:
         *    3.1 App registers for location updates
         */
        if #available(iOS 9.0, *) {
            manager.requestAlwaysAuthorization()
        }
        
        if #available(iOS 9.0, *) {
            manager.allowsBackgroundLocationUpdates = true
        }
        
        rotationResetButton.resetDuration = rotationDuration
        
        scaleBar.initialize()
        scaleBar.map = map
        
        rotationListener = RotationListener()
        rotationListener.map = map
        
        locationButton.initialize(onImageUrl: "icon_track_location_on.png", offImageUrl: "icon_track_location_off.png")
        
        routeButton.initialize(onImageUrl: "route.png", offImageUrl: "route.png")
        
        progressLabel = ProgressLabel()
        view.addSubview(progressLabel)
        
        routeController = RouteController(mapView: self.map, progressLabel: self.progressLabel)
        
    }
    
    
    // ROTATION FIX FOR MAP DISPLAYING BAD IN LANDSCAPE
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let cartoTitleOff = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 50)
        map.frame = cartoTitleOff
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        manager.startUpdatingLocation()
//        manager.startUpdatingHeading()
        
        rotationListener?.delegate = self
        map.setMapEventListener(rotationListener)
        
        locationButton.delegate = self
        routeButton.delegate = self
    }
    
    // MARK: LOCATION BUTTON DELEGATE
    func locationSwitchTapped(){
        if (locationButton.isActive()){
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        } else {
            manager.stopUpdatingLocation()
            manager.stopUpdatingHeading()
        }
    }
    
    // MARK: ROUTE BUTTON DELEGATE
    func routeSwitchTapped() {
        if (routeButton.isActive()){
            layoutProgressLabel()
            routeController.startRoute()
        } else {
            routeController.finishRoute()
        }
    }
    
    // TODO : NECESITO HACERLO EL DISEÑO EN EL STORYBOARD
    func layoutProgressLabel() {
        
        let w: CGFloat = view.frame.width
        let h: CGFloat = 40
        let x: CGFloat = 0
        let y: CGFloat = view.frame.height - h
        
        progressLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    

    //MARK: LOCATION MANAGER METHOD DELEGATE
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Latest location saved as class variable to get bearing to adjust compass
        latestLocation = locations[0]
        
        // Not "online", but reusing the online switch to achieve location tracking functionality
        if (locationButton.isActive()) {
            locationMarker.showUserAt(location: latestLocation)
        }
    }
    
    //MARK: END LOCATION MANAGER
    
    @IBAction func rotate(_ sender: UITapGestureRecognizer) {
        isRotationInProgress = true
        map.setRotation(0, durationSeconds: rotationDuration)
        rotationResetButton.reset()
        Timer.scheduledTimer(timeInterval: TimeInterval(rotationDuration + 0.1), target: self, selector: #selector(onRotationCompleted), userInfo: nil, repeats: false)
    }
    
    let rotationDuration: Float = 0.4
    var isRotationInProgress = false
    
    func onRotationCompleted() {
        isRotationInProgress = false
    }
    
    func rotated(angle: CGFloat) {
        if (self.isRotationInProgress) {
            // Do not rotate when rotation reset animation is in progress
            return
        }
        self.rotationResetButton.rotate(angle: angle)
    }
    
    func zoomed(zoom: CGFloat) {
        self.scaleBar.update()
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }

    
    
}
