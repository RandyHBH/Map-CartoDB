 //
 //  ViewController.swift
 //  WeGoCuba
 //
 //  Created by Randy Hector Bartumeu Huergo on 8/29/17.
 //  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
 //
 
 import UIKit
 import CoreLocation
 
 
 class MapViewController: UIViewController, CLLocationManagerDelegate, PTPButtonDelegate {
    
    var map: NTMapView!
    @IBOutlet var mapContainer: UIView!
    
    @IBOutlet var rotationResetButton: RotationResetButton!
    @IBOutlet weak var leftMenuButton: UIButton!
    
    @IBOutlet var routeButtonsView: RouteButtonsView!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var routingChoices: RoutingChoices!
    @IBOutlet weak var routingPositionsSelect: RoutingPositionsSelect!
    @IBOutlet weak var ptpContainer: UIView!
    
    @IBOutlet weak var infoBar: InfoBar!
    
    var mapModel: MapModel = DataContainer.instance.mapModel
    
    var showPtpContainer = false
    
    // MARK: LOCATIONS MARKERS
    var locationMarker: LocationMarker!
    
    // MARK: BASIC BRUJALA & MAP EVENTS DECLARATION
    var basicEvents: BasicMapEvents!
    
    // MARK: BASIC GPS LOCALIZATION DECLARATION
    var manager: CLLocationManager!
    var latestLocation: CLLocation!
    
    // MARK: BASIC DECLARATION FOR OFFLINE ROUTE
    //    var progressLabel: ProgressLabel!
    
    var routeController: RouteController!
    
    // MARK: ROTATION FIX FOR MAP DISPLAYING BAD IN LANDSCAPE
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let cartoTitleOff = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 50)
        map.frame = cartoTitleOff
    }
    
    // MARK: CLASS INSTANCE
    class func newInstance() -> MapViewController? {
        let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        return mapVC
    }
    
    // MARK: CORE LOCATION METHODS
    func startLocationUpdates() {
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func stopLocationUpdates() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
    
    // MARK: PTPBUTTON DELEGATE
    var isRoutingChoisesViewActive = false
    var isRoutingPositionsSelectViewActive = false
    var isRotationButtonUp = true
    
    func ptpButtonTapped(first routingChoisesState: Bool, second routePointsSelectViewState: Bool) {
        
        hideRoutingChoicesView(state: routingChoisesState)
        hideRoutePointsSelectionView(state: routePointsSelectViewState)
        if (routingChoisesState == false) && (routePointsSelectViewState == true) {
            return
        } else {
            if routingChoices.isDownButtonActive {
               return
            }
            routingChoices.rotateDownButton()
        }
    }
    
    func hideRoutingChoicesView(state: Bool = true) {
        DispatchQueue.main.async {
            self.menuContainer.isHidden = state
            self.routingChoices.isHidden = state
        }
    }
    
    func hideRoutePointsSelectionView(state: Bool = true) {
        DispatchQueue.main.async {
            self.routingPositionsSelect.isHidden = state
        }
    }
    
    //MARK: CORE LOCATION MANAGER METHOD DELEGATE
    var mFirstLocationUpdated = true
    var course: Float = -1
    var hasCourse: Bool {
        get { return course != -1 }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        latestLocation = DataContainer.instance.latestLocation
        
        if (latestLocation != nil) {
            if (latestLocation.coordinate.latitude == location.coordinate.latitude) {
                if (latestLocation.coordinate.longitude == location.coordinate.longitude) {
                    
                    return
                }
            }
        }
        
        latestLocation = location
        DataContainer.instance.latestLocation = latestLocation
        
        guard !mFirstLocationUpdated else {
            
            locationMarker.showUserAt(location: location)
            mFirstLocationUpdated = false
            return
        }
        
        locationMarker.showUserAt(location: location)
        
        // rotate marker, depending on marker graphics
        // "180-course" is ok if it is "arrow down"
        // additional adjustment is for mapView rotation, image keeps
        // here correct course even if map is rotated
        
        let course = location.course;
        let float = Float(course)
        self.course = float
        
        // Only use course if it's available,
        // else update heading from didUpdateHeading function
        if (hasCourse) {
            let angle = 180 - float - map.getRotation();
            locationMarker.rotate(rotation: angle)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        if (newHeading.headingAccuracy < 0) {
            // Ignore if there's no accuracy, no point in processing it
            return
        }
        
        if (!hasCourse) {
            // Use true heading if it is valid.
            let heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading)
            
            let angle = -Float(heading) - map.getRotation();
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
 }
 
 extension MapViewController {
    
    func setupStatusBarColor() {
        let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
        let statusBarView = statWindow.subviews[0] as UIView
        statusBarView.backgroundColor = Colors.appBlue
        statusBarView.tag = 100
        self.navigationController?.view.addSubview(statusBarView)
    }
 }
 
 extension MapViewController: RotationDelegate {
    
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
 
 extension MapViewController: GoButtonDelegate {
    
    func goButtonTapped(navigationVCInfo: NavigationInfo) {
        if let navigationVC = NavigationViewController.newInstance() {
            
            navigationVC.map = self.map
            navigationVC.locationMarker = self.locationMarker
            navigationVC.routeController = self.routeController
            navigationVC.routeInfo = navigationVCInfo.routeInfo
            
            present(navigationVC, animated: true, completion: nil)
        }
    }
 }
