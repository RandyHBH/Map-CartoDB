//
//  ViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 8/29/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, RotationDelegate, BasicMapEventsDelgate, LocationButtonDelegate, RouteButtonDelegate {
    
    @IBOutlet var map: NTMapView!
    @IBOutlet var locationButton: LocationButton!
    @IBOutlet var scaleBar: ScaleBar!
    @IBOutlet var rotationResetButton: RotationResetButton!
    @IBOutlet var routeButton: RouteButton!
    
    
    // BASIC MAP DECLARATION
    var projection: NTProjection!
    var baseMap : BaseMap!
    
    // LOCATIONS MARKERS
    var locationMarker : LocationMarker!
    
    
    // BASIC BRUJALA & MAP EVENTS DECLARATION
    var basicEvents: BasicMapEvents!
    
    // BASIC GPS LOCALIZATION DECLARATION
    var manager: CLLocationManager!
    var latestLocation: CLLocation!
    var isUpdatingLocation : Bool = false
    
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
        //        manager.desiredAccuracy = 1
        
        if #available(iOS 9.0, *) {
            manager.requestAlwaysAuthorization()
        }
        
        
        rotationResetButton.resetDuration = rotationDuration
        
        scaleBar.initialize()
        scaleBar.map = map
        
        basicEvents = BasicMapEvents()
        basicEvents.map = map
        
        progressLabel = ProgressLabel()
        view.addSubview(progressLabel)
        layoutProgressLabel()
        
        routeController = RouteController(mapView: self.map, progressLabel: self.progressLabel)
        
    }
    
    
    // ROTATION FIX FOR MAP DISPLAYING BAD IN LANDSCAPE
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let cartoTitleOff = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 50)
        map.frame = cartoTitleOff
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLocationUpdates()
        
        basicEvents?.delegateRotate = self
        basicEvents?.delegateBasicMapEvents = self
        
        map.setMapEventListener(basicEvents)
        
        locationButton.delegate = self
        locationButton.addRecognizer()
        
        routeButton.addRecognizer()
        routeButton.delegate = self
        
    }
    
    // MARK: LOCATION BUTTON DELEGATE
    func locationSwitchTapped() {
        
        switch locationButton.isActive() {
        case true:
            if (isUpdatingLocation == true) {
                // Don't do nothing
            } else {
                startLocationUpdates()
            }
        default:
            if (isUpdatingLocation == true) {
                stopLocationUpdates()
            } else {
                // Don't do nothing
            }
        }
    }
    
    func startLocationUpdates() {
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
        isUpdatingLocation = true
    }
    
    func stopLocationUpdates() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        
        isUpdatingLocation = false
    }
    
    // MARK: ROUTE BUTTON DELEGATE
    
    var navigationStarted : Bool = false
    
    func routeButtonTapped() {
        if ( basicEvents.stopPosition != nil) {
            
            let latitude = Double(latestLocation.coordinate.latitude)
            let longitude = Double(latestLocation.coordinate.longitude)
            
            let startPosition = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
            
            let stopPosition = basicEvents.stopPosition
            
            routeController.showRoute(start: startPosition!, stop: stopPosition!)
            
            navigationStarted = true
            startLocationUpdates()
            
        } else {
            
            self.progressLabel.complete(message: "You need to set a final position")
        }
        
    }
    
    // MARK: BASIC MAP EVENTS DELEGATE
    
    func stopPositionSet(event: RouteMapEvent) {
        
        routeController.onePointRoute(event: event)
    }
    
    func stopPositionUnSet() {
        
        routeController.finishRoute()
    }
    
    func longTap(){
        
        // NO RESPONDER A LOS LONG-TAPS
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
        let location = locations[0]
        
        if (latestLocation.coordinate.latitude == location.coordinate.latitude) {
            if (latestLocation.coordinate.longitude == location.coordinate.longitude) {
                return
            }
        }
        
        latestLocation = location
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        locationMarker.showUserAt(location: latestLocation)
        
        // Zoom & focus is enabled by default, disable after initial location is set
        locationMarker.focus = false
        
        // Only enabled Zoom & focus if locationButton change his state
        if (locationButton.isActive()) {
            locationMarker.focus = true
        } else {
            locationMarker.focus = false
        }
        
        var destination =  basicEvents.stopPosition
        
        if (destination != nil) {
            if (navigationStarted) {
                let position = locationMarker.projection.fromLat(latitude, lng: longitude)
                if (position != destination) {
                    routeController.showRoute(start: position!, stop: destination!)
                } else {
                    destination = nil
                    routeController.finishRoute()
                }
            }
        }
    }
    
    
    //MARK: END LOCATION MANAGER
    
    // ROTATE BUTTON
    
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
    
    
}
