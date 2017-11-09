 //
 //  ViewController.swift
 //  WeGoCuba
 //
 //  Created by Randy Hector Bartumeu Huergo on 8/29/17.
 //  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
 //
 
 import UIKit
 import CoreLocation
 
 
 class MapViewController: UIViewController, CLLocationManagerDelegate, RotationDelegate, BasicMapEventsDelgate, PTPButtonDelegate {
    
    @IBOutlet var map: NTMapView!
    @IBOutlet var rotationResetButton: RotationResetButton!
    @IBOutlet var routeButtonsView: RouteButtonsView!
    
    // TODO: Verify where need to be. Now is in RouteButtonsView and here
    @IBOutlet weak var routingChoices: RoutingChoices!
    
    // MARK: BASIC MAP DECLARATION
    var projection: NTProjection!
    var baseMap: BaseMap!
    
    // MARK: LOCATIONS MARKERS
    var locationMarker: LocationMarker!
    
    // MARK: BASIC BRUJALA & MAP EVENTS DECLARATION
    var basicEvents: BasicMapEvents!
    
    // MARK: BASIC GPS LOCALIZATION DECLARATION
    var manager: CLLocationManager!
    var latestLocation: CLLocation!
    var isUpdatingLocation: Bool = false
    
    // MARK: BASIC DECLARATION FOR OFFLINE ROUTE
    var progressLabel: ProgressLabel!
    
    var routeController: RouteController!
    
    // MARK: TIMER
    var timer = Timer()
    var seconds = 5
    var isTimerRunning = false
    
    // MARK:
    var active = true
    
    // MARK: ROTATION FIX FOR MAP DISPLAYING BAD IN LANDSCAPE
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let cartoTitleOff = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 50)
        map.frame = cartoTitleOff
    }
    
    // MARK: CLASS INSTANCE
    class func newInstance() -> MapViewController {
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        return mapVC
    }
    
    // MARK: CORE LOCATION METHODS
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
    
    // MARK: BASIC MAP EVENTS DELEGATE
    func stopPositionSet(event: RouteMapEvent) {
        
        self.routeController?.onePointRoute(event: event)
        
        routeButtonsView.showHideRouteButton()
        showHideNavigationBar()
    }
    
    func stopPositionUnSet() {
        
        self.basicEvents?.stopPosition = nil
        self.routeController?.finishRoute()
        self.locationMarker?.modeFree()
        
        routeButtonsView.showHideRouteButton()
        showHideNavigationBar()
    }
    
    func longTap(){
        // NO RESPONDER A LOS LONG-TAPS
    }
    
    // MARK: PTPBUTTON DELEGATE
    func ptpButtonTapped() {
        showHideNavigationBar()
    }
    
    // MARK: ROUTE BUTTON DELEGATE
    var navigationMode = false
    var navigationInProgress = false
    
    // TODO: NECESITO HACERLO EL DISEÑO EN EL STORYBOARD
    func layoutProgressLabel() {
        
        let w: CGFloat = view.frame.width
        let h: CGFloat = 40
        let x: CGFloat = 0
        let y: CGFloat = view.frame.height - h
        
        progressLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    //MARK: CORE LOCATION MANAGER METHOD DELEGATE
    var mFirstLocationUpdated = true
    var course: Float = -1
    var hasCourse: Bool {
        get { return course != -1 }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        latestLocation = DataContainer.sharedInstance.latestLocation
        
        if (latestLocation != nil) {
            if (latestLocation.coordinate.latitude == location.coordinate.latitude) {
                if (latestLocation.coordinate.longitude == location.coordinate.longitude) {
                    
                    return
                }
            }
        }
        
        latestLocation = location
        DataContainer.sharedInstance.latestLocation = latestLocation
        
        guard !mFirstLocationUpdated else {
            
            locationMarker.showUserAt(location: location)
            locationMarker.modeFree()
            mFirstLocationUpdated = false
            return
        }
        
        
        locationMarker.showUserAt(location: location)
        
        // rotate marker, depending on marker graphics
        // "180-course" is ok if it is "arrow down"
        // additional adjustment is for mapView rotation, image keeps
        // here correct course even if map is rotated
        
        let course = location.course;
        let float = Float(exactly: course)!
        
        self.course = float
        
        // Only use course if it's available,
        // else update heading from didUpdateHeading function
        if (hasCourse) {
            let angle = 180 - float - map.getRotation();
            locationMarker.rotate(rotation: angle)
        }
        
        
        if (self.routeController.result != nil) && (navigationMode == true) {
            
            self.routeController.updateRoute(location: location)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if (newHeading.headingAccuracy < 0) {
            // Ignore if there's no accuracy, no point in processing it
            return
        }
        
        // Only use heading if course isn't available.
        if (!hasCourse) {
            // Use true heading if it is valid.
            let heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading)
            let angle = -Float(exactly: heading)!
            locationMarker.rotate(rotation: angle)
        }
    }
    
    // MARK: ROTATE BUTTON
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
        
    }
    
    
 }
