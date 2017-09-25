//
//  ViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 8/29/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, SwitchDelegate {
    
    let RASTER_IMAGE = false
    let SEARCH = true
    
    @IBOutlet var map: NTMapView!
    
    var projection: NTProjection!
    var source: NTLocalVectorDataSource!
    
    var buttons : [PopupButton]?
    var switchButton: SwitchButton!
    
    var manager: CLLocationManager!
    var latestLocation: CLLocation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = NTMapView()
        map.frame = view.bounds
        
        //Need to add as a subview
        view.addSubview(map)
        
        // Load MBTiles Raster Tiles o MBTiles Vector Tiles
        if RASTER_IMAGE {
            loadRasterDataSource()
        } else {
            loadVectorDataSource()
        }
        
        // Get base projection from mapView
        projection = map.getOptions().getBaseProjection();
        
        //Creating Layer to store the markers, i think :)
        source =  NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        map.getLayers().add(layer)
        
        
        //Creating a botton & add to array for later given a position
        switchButton = SwitchButton(onImageUrl: "icon_track_location_on.png", offImageUrl: "icon_track_location_off.png")
        switchButton.delegate = self
        addButton(button: switchButton)
        
        layoutSubviews()
        
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
        map.getOptions().setPanningMode(NTPanningMode.PANNING_MODE_STICKY)
        
        startLocationUpdate()
        
    }
    
    //MARK: SWITCH BUTTON DELEGATE & LOCATION UPDATE START/STOP
    internal func switchChanged() {
        
        if switchButton.isOnline() {
            startLocationUpdate()
        } else {
            stopLocationUpdate()
        }
    }
    
    func startLocationUpdate() {
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func stopLocationUpdate() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
    
    //MARK: END SWITCH BUTTON DELEGATE & LOCATION UPDATE START/STOP
    
    //MARK: RASTER METHODS
    
    func loadRasterDataSource() {
        // Create a local raster data source
        let source: String? = createRasterDataSource()
        
        let tileDataSource = NTMBTilesTileDataSource(minZoom: 0, maxZoom: 14, path: source)
        let rasterLayer = NTRasterTileLayer(dataSource: tileDataSource)
        map?.getLayers()?.add(rasterLayer)
    }
    
    func createRasterDataSource() -> String {
        let name: String = "cuba.output"
        let format : String = "mbtiles"
        // file-based local offline datasource
        let source: String? = Bundle.main.path(forResource: name, ofType: format)
        return source!
    }
    
    //MARK: END RASTER METHODS
    
    //MARK: VECTOR METHODS
    
    func loadVectorDataSource() {
        // Create a local vector data source
        let source: NTTileDataSource? = createTileDataSource()
        
        let baseLayer = NTCartoOnlineVectorTileLayer(style: .CARTO_BASEMAP_STYLE_VOYAGER)
        let decoder: NTVectorTileDecoder? = baseLayer?.getTileDecoder()
        let layer = NTVectorTileLayer(dataSource: source, decoder: decoder)
        map?.getLayers()?.add(layer)
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
    
    //MARK: LOCATION METHODS
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Latest location saved as class variable to get bearing to adjust compass
        latestLocation = locations[0]
        
        // Not "online", but reusing the online switch to achieve location tracking functionality
        if (switchButton.isOnline()) {
            showUserAt(location: latestLocation)
        }
    }
    
    //MARK: END LOCATION METHODS
    
    var userMarker: NTPoint!
    var accuracyMarker: NTPolygon!
    
    func showUserAt(location: CLLocation) {
        
        let latitude = Double(location.coordinate.latitude)
        let longitude = Double(location.coordinate.longitude)
        let accuracy = Float(location.horizontalAccuracy)
        
        let position = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
        
        map.setFocus(position, durationSeconds: 1)
        map.setZoom(9, durationSeconds: 1)
        
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
    
    //MARK: BUTTONS
    
    func addButton(button: PopupButton) {
        
        if (buttons == nil) {
            buttons = [PopupButton]()
        }
        
        buttons!.append(button)
        view.addSubview(button)
    }
    
    //MARK: END BUTTONS
    
    //MARK: LAYOUT SUBVIEWS
    
    let bottomLabelHeight: CGFloat = 25
    let smallPadding: CGFloat = 5
    
    func layoutSubviews() {
        
        let count = CGFloat(self.buttons!.count)
        
        let buttonWidth: CGFloat = 40
        let innerPadding: CGFloat = 15
        
        let totalArea = buttonWidth * count + (innerPadding * (count - 1))
        
        let w: CGFloat = buttonWidth
        let h: CGFloat = w
        let y: CGFloat = view.frame.height - (bottomLabelHeight + h + smallPadding)
        var x: CGFloat = view.frame.width / 2 - totalArea / 2
        
        for button in buttons! {
            button.frame = CGRect(x: x, y: y, width: w, height: h)
            
            x += w + innerPadding
        }
        
        
    }
    
}
