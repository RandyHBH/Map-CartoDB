 //
 //  ViewController.swift
 //  WeGoCuba
 //
 //  Created by Randy Hector Bartumeu Huergo on 8/29/17.
 //  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
 //
 
 import UIKit
 import CoreLocation
 
 
 class ViewController: UIViewController, CLLocationManagerDelegate, RotationDelegate, BasicMapEventsDelgate, LocationButtonDelegate, RouteButtonDelegate, PTPButtonDelegate, MapIsInactiveDelegate {
    
    @IBOutlet var map: NTMapView!
    @IBOutlet var locationButton: LocationButton!
    @IBOutlet var scaleBar: ScaleBar!
    @IBOutlet var rotationResetButton: RotationResetButton!
    @IBOutlet var routeButton: RouteButton!
    
    @IBOutlet var ptpButton: PTPButton!
    
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
        map.getOptions().setZoom(NTMapRange(min: 5, max: 22))
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
        map?.setFocus(projection?.fromWgs84(NTMapPos(x: -82.2906, y: 23.0469)), durationSeconds: 0)
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
        
        // START UPDATING LOCATION, WHEN STOP THE UPDATES????
        startLocationUpdates()
        
        basicEvents?.delegateRotate = self
        basicEvents?.delegateBasicMapEvents = self
        basicEvents?.delegateMapIsInactive = self
        
        map.setMapEventListener(basicEvents)
        
        locationButton.delegate = self
        locationButton.addRecognizer()
        
        routeButton.addRecognizer()
        routeButton.delegate = self
        
        ptpButton.addRecognizer()
        ptpButton.delegate = self
        
        self.routeController.locationMarker = self.locationMarker
        
    }
    
    // MARK: LOCATION BUTTON DELEGATE
    func locationSwitchTapped() {
        
        if (latestLocation != nil) {
            
            let latitude = Double(latestLocation.coordinate.latitude)
            let longitude = Double(latestLocation.coordinate.longitude)
            
            let position = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
            
            map.setZoom(18, durationSeconds: 2)
            map.setFocus(position, durationSeconds: 1)
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
    
    var navigationMode = false
    var navigationInProgress = false
    
    func routeButtonTapped() {
        
        if ( basicEvents.stopPosition != nil) && (navigationMode == false) && (latestLocation != nil) && (navigationInProgress != true) {
            
            let latitude = Double(latestLocation.coordinate.latitude)
            let longitude = Double(latestLocation.coordinate.longitude)
            
            let startPosition = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
            
            let stopPosition = basicEvents.stopPosition
            
            self.routeController.showRoute(start: startPosition!, stop: stopPosition!)
            
            self.navigationMode = true
            self.navigationInProgress = true
            basicEvents.navigationMode = true
            self.locationMarker.modeNavigation()
            
        } else if (navigationInProgress == true) {
            
            stopPositionUnSet()
            basicEvents.stopPosition = nil
        } else {
            
            navigationMode = false
            self.progressLabel.complete(message: "You need to set a final position")
        }
        
    }
    
    // MARK: PTP BUTTON DELEGATE
    // TODO
    func ptpButtonTapped() {
        
        routeController.startRoute()
    }
    
    // MARK: BASIC MAP EVENTS DELEGATE
    
    func stopPositionSet(event: RouteMapEvent) {
        
        routeController.onePointRoute(event: event)
    }
    
    func stopPositionUnSet() {
        
        routeController.finishRoute()
        
        navigationMode = false
        navigationInProgress = false
        basicEvents.navigationMode = false
        
        
        self.locationMarker.modeFree()
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
    
    var mFirstLocationUpdated = true
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        if (latestLocation != nil) {
            if (latestLocation.coordinate.latitude == location.coordinate.latitude) {
                if (latestLocation.coordinate.longitude == location.coordinate.longitude) {
                    
                    return
                }
            }
        }
        
        latestLocation = location
        
        
        if mFirstLocationUpdated {
            
            locationMarker.showUserAt(location: location)
            locationMarker.modeFree()
            mFirstLocationUpdated = false
            return
        }
        
        if (navigationMode == false) {
            locationMarker.showUserAt(location: location)
            
        } else if (self.routeController.result != nil) && (navigationMode == true) {
            
            self.routeController.updateRoute(location: location)
            
        }
    }
    
    // MARK: TIMER
    
    var timer = Timer()
    var seconds = 5
    var isTimerRunning = false
    
    func startTimer() {
        if isTimerRunning == false {
            runTimer()
        }
    }
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
        isTimerRunning = true
        routeController.isTimerRunning = true
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            if navigationInProgress {
                locationMarker.modeNavigation()
            }
            routeController.isTimerRunning = false
        } else {
            
            seconds -= 1
        }
    }
    
    func resetTimer() {
        timer.invalidate()
        seconds = 5
        
        isTimerRunning = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if (newHeading.headingAccuracy < 0) {
            // Ignore if there's no accuracy, no point in processing it
            return
        }
        
        // Use true heading if it is valid.
        
        // TODO: I DONT KNOW HOW TO ROTATE THE LOCATION MARKER
        let heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading)
        
        locationMarker.course = Float(heading)
        // TODO calculate heading to see whether the user should turn around or is facing the correct direction
        
    }
    
    // MARK: END LOCATION MANAGER
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
