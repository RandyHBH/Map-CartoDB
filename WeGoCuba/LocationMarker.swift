//
//  LocationMarker.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/9/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation
import CoreLocation


class LocationMarker: NSObject {
    
    var map : NTMapView!
    
    var source : NTLocalVectorDataSource!
    var projection : NTProjection!
    
    var markerImage : UIImage!
    
    init(mapView : NTMapView) {
        super.init()
        
        self.map = mapView
        
        projection = self.map.getOptions().getBaseProjection()
        source = NTLocalVectorDataSource(projection: projection)
        let layer = NTVectorLayer(dataSource: source)
        map.getLayers().add(layer)
    }
    
    //MARK: LOCATION METHODS
    
    var isNavigationMode = false
    var navigationModeFirstTime = true
    
    var freeMode: Bool = true
    var speed: Double!
    var rotation: Float!
    var course: Float!
    
    var userMarker: NTMarker!
    var navigationPointer: NTMarker!
    var accuracyMarker: NTPolygon!
    
    func showUserAt(location: CLLocation) {
        
        speed = location.speed
        
        let latitude = Double(location.coordinate.latitude)
        let longitude = Double(location.coordinate.longitude)
        let accuracy = Float(location.horizontalAccuracy)
        
        showAt(latitude: latitude, longitude: longitude, accuracy: accuracy)
    }
    
    func showAt(latitude: Double, longitude: Double, accuracy: Float) {
        
        let position = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
        
        if (isNavigationMode == true) {
            if (navigationModeFirstTime) {
                
                source.remove(userMarker)
                source.remove(accuracyMarker)
                
                source.add(navigationPointer)
                
                navigationModeFirstTime = false
            }
            
            navigationPointer.setPos(position)
            
            return
        }
        
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
            let builder = NTMarkerStyleBuilder()
            self.markerImage = UIImage(named: "ic_navigation_white")
            builder?.setBitmap(NTBitmapUtils.createBitmap(from: markerImage))
            builder?.setColor(Colors.appleBlue.toNTColor())
            builder?.setAnchorPointX(0, anchorPointY: 0)
            builder?.setSize(25.0)
            
            userMarker = NTMarker(pos: position, style: builder?.buildStyle())
            source.add(userMarker)
        }
        if (navigationPointer == nil) {
            let builder = NTMarkerStyleBuilder()
            self.markerImage = UIImage(named: "ic_navigation_white")
            builder?.setBitmap(NTBitmapUtils.createBitmap(from: markerImage))
            builder?.setColor(Colors.appleBlue.toNTColor())
            builder?.setSize(25.0)
            builder?.setAnchorPointX(0, anchorPointY: 0)
            builder?.setOrientationMode(.BILLBOARD_ORIENTATION_FACE_CAMERA_GROUND)
            navigationPointer = NTMarker(pos: position, style: builder?.buildStyle())
        }
        
        userMarker.setPos(position)
        navigationPointer.setPos(position)
    }
    
    func rotate(rotation: Float) {
        if (isNavigationMode == true) {
            navigationPointer.setRotation(rotation)
            return
        }
        if (userMarker == nil) {
            return
        }
        userMarker.setRotation(rotation)
    }
    
    func focus() {
        map.setTilt(30, durationSeconds: 0)
        map.setFocus(navigationPointer.getBounds().getCenter(), durationSeconds: 0)
    }
    
    func autoZoom(speed : Double, position : NTMapPos) {
        let speedKmH = speed * 3.6
        if (speedKmH >= 80) {
            map.setZoom(17, targetPos: position, durationSeconds: 2)
        } else if (speedKmH >= 70) {
            map.setZoom(18, targetPos: position, durationSeconds: 2)
        } else if (speedKmH >= 50) {
            map.setZoom(19, targetPos: position, durationSeconds: 2)
        } else {
            map.setZoom(19, targetPos: position, durationSeconds: 2)
        }
    }
    
    func NTBitmapFromString(path: String) -> NTBitmap {
        let image = UIImage(named: path)
        return NTBitmapUtils.createBitmap(from: image)
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
}
