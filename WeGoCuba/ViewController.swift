//
//  ViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 8/29/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, RotationDelegate, LocationButtonDelegate,RouteButtonDelegate, RouteMapEventDelegate {
    
    @IBOutlet var map: NTMapView!
    @IBOutlet var locationButton: LocationButton!
    @IBOutlet var routeButton: RouteButton!
    @IBOutlet var scaleBar: ScaleBar!
    @IBOutlet var rotationResetButton: RotationResetButton!
    
    
    // BASIC MAP DECLARATION
    
    var projection: NTProjection!
    var source: NTLocalVectorDataSource!
    
    // BASIC BRUJALA DECLARATION
    var rotationListener: RotationListener!
    
    // BASIC GPS LOCALIZATION DECLARATION
    var manager: CLLocationManager!
    var latestLocation: CLLocation!
    
    // BASIC DECLARATION FOR OFFLINE ROUTE
    var progressLabel: ProgressLabel!
    var mapListener: RouteMapEventListener!
    var routing: Routing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = NTMapView()
        let cartoTitleOff = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height + 50)
        map.frame = cartoTitleOff
        
        map.getOptions().setZoomGestures(true)
        map.getOptions().setPanningMode(NTPanningMode.PANNING_MODE_STICKY)
        
        //Need to add as a subview
        view.insertSubview(map, at: 1)
        
        // Load MBTiles Raster Tiles o MBTiles Vector Tiles
        loadVectorDataSource()
        
        // Get base projection from mapView
        projection = map.getOptions().getBaseProjection();
        
        //Creating Layer to store the markers, i think :)
        source =  NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        map.getLayers().add(layer)
        
        
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
        
        mapListener = RouteMapEventListener()
        
    }
    
    
    // ROTATION FIX FOR MAP DISPLAYING BAD IN LANDSCAPE
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let cartoTitleOff = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 50)
        map.frame = cartoTitleOff
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        
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
        let actualEventsSave = map.getMapEventListener()
        
        if (routeButton.isActive()){
            layoutProgressLabel()
            mapListener.delegate = self
            map.setMapEventListener(mapListener)
            routing = Routing(mapView: map)
        } else {
            
            mapListener.delegate = nil
            map.setMapEventListener(nil)
            map.setMapEventListener(actualEventsSave)
        }
    }
    
    func layoutProgressLabel() {
        
        let w: CGFloat = view.frame.width
        let h: CGFloat = 40
        let x: CGFloat = 0
        let y: CGFloat = view.frame.height - h
        
        progressLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    func singleTap() {
        // No actions for single tap
    }
    
    func startClicked(event: RouteMapEvent) {
        DispatchQueue.main.async(execute: {
            self.routing.setStartMarker(position: event.clickPosition)
            self.progressLabel.hide()
        })
    }
    
    func stopClicked(event: RouteMapEvent) {
        routing.setStopMarker(position: event.clickPosition)
        showRoute(start: event.startPosition, stop: event.stopPosition)
    }
    
    func showRoute(start: NTMapPos, stop: NTMapPos) {
        DispatchQueue.global().async {
            
            let result: GHResponse? = self.routing.getResult(startPos: start, stopPos: stop)
            
            DispatchQueue.main.async(execute: {
                if (result == nil) {
                    self.progressLabel.complete(message: "Routing failed. Please try again")
                    return
                } else {
                    self.progressLabel.complete(message: self.routing.getMessage(result: result!))
                }
                
                let color = NTColor(r: 14, g: 122, b: 254, a: 150)
                self.routing.show(result: result!, lineColor: color!, complete: {
                    (route: Route) in
                    
                })
            })
        }
    }
    
    //MARK: VECTOR METHODS
    
    func loadVectorDataSource() {
        // Create a local vector data source
        let source: NTTileDataSource? = createTileDataSource()
        let newbaseLayer = NTCartoOfflineVectorTileLayer(dataSource: source, style: .CARTO_BASEMAP_STYLE_VOYAGER)
        
        map?.getLayers()?.add(newbaseLayer)
    }
    
    func createTileDataSource() -> NTTileDataSource {
        let name: String = "cuba"
        let format : String = "mbtiles"
        // file-based local offline datasource
        let source: String? = Bundle.main.path(forResource: name, ofType: format)
        let vectorTileDataSource: NTTileDataSource? = NTMBTilesTileDataSource(minZoom: 0, maxZoom: 14, path: source)
        return vectorTileDataSource!
    }
    
    //MARK: END VECTOR METHODS
    
    //MARK: LOCATION MANAGER METHOD DELEGATE
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Latest location saved as class variable to get bearing to adjust compass
        latestLocation = locations[0]
        
        // Not "online", but reusing the online switch to achieve location tracking functionality
        if (locationButton.isActive()) {
            showUserAt(location: latestLocation)
        }
    }
    
    //MARK: END LOCATION MANAGER
    
    //MARK: LOCATION METHODS
    
    var userMarker: NTPoint!
    var accuracyMarker: NTPolygon!
    
    func showUserAt(location: CLLocation) {
        
        let latitude = Double(location.coordinate.latitude)
        let longitude = Double(location.coordinate.longitude)
        let accuracy = Float(location.horizontalAccuracy)
        
        let position = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
        
        map.setFocus(position, durationSeconds: 1)
        map.setZoom(14, durationSeconds: 1)
        
        let builder = NTPolygonStyleBuilder()
        builder?.setColor(Colors.lightTransparentAppleBlue.toNTColor())
        
        let borderBuilder = NTLineStyleBuilder()
        borderBuilder?.setColor(Colors.darkTransparentAppleBlue.toNTColor())
        borderBuilder?.setWidth(1)
        
        builder?.setLineStyle(borderBuilder?.buildStyle())
        
        let points = getCirclePoints(latitude: latitude, longitude: longitude, accuracy: accuracy)
        
        if (accuracyMarker == nil) {
            accuracyMarker = NTPolygon(poses: points, holes: NTMapPosVectorVector(), style: builder?.buildStyle())
            source.add(accuracyMarker)
        } else {
            accuracyMarker.setStyle(builder?.buildStyle())
            accuracyMarker.setGeometry(NTPolygonGeometry(poses: points))
        }
        
        if (userMarker == nil) {
            let builder = NTPointStyleBuilder()
            builder?.setColor(Colors.appleBlue.toNTColor())
            builder?.setSize(16.0)
            
            userMarker = NTPoint(pos: position, style: builder?.buildStyle())
            source.add(userMarker)
        }
        
        userMarker.setPos(position)
    }
    
    func getCirclePoints(latitude: Double, longitude: Double, accuracy: Float) -> NTMapPosVector {
        // Number of points of circle
        let N = 100
        let EARTH_RADIUS = 6378137.0
        
        let radius = Double(accuracy)
        
        let points = NTMapPosVector()
        
        for i in stride(from: 0, to: N, by: 1) {
            
            let angle = Double.pi * 2 * (Double(i).truncatingRemainder(dividingBy:Double(N))) / Double(N)
            let dx = radius * cos(angle)
            let dy = radius * sin(angle)
            
            let lat = latitude + (180 / Double.pi) * (dy / EARTH_RADIUS)
            let lon = longitude + (180 / Double.pi) * (dx / EARTH_RADIUS) / cos(Double(latitude * Double.pi / 180))
            
            let point = projection.fromWgs84(NTMapPos(x: lon, y: lat))
            points?.add(point)
        }
        
        return points!
    }
    
    //MARK: END LOCATION METHODS
    
    
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
