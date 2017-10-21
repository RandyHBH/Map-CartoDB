//
//  RouteController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/9/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation
import CoreLocation

class RouteController: NSObject, RouteMapEventDelegate {
    
    var map : NTMapView!
    var projection : NTProjection!
    var hopper: GraphHopper!
    var routing: Routing!
    var mapListener: RouteMapEventListener!
    var actualEventsSave : NTMapEventListener!
    var progressLabel : ProgressLabel!
    
    var locationMarker: LocationMarker!
    
    var result: GHResponse?
    
    init(mapView : NTMapView, progressLabel : ProgressLabel) {
        super.init()
        
        self.map = mapView
        self.projection = map.getOptions().getBaseProjection()
        self.progressLabel = progressLabel
        
        initGraphhoper()
        
        mapListener = RouteMapEventListener()
        
        routing = Routing(mapView: self.map, hopper: self.hopper)
    }
    
    func initGraphhoper(){
        let location: String? = Bundle.main.path(forResource: "graph-data", ofType: "osm-gh")
        self.hopper = GraphHopper()
        self.hopper.getCHWeightings().add(withId: "shortest")
        self.hopper.getCHFactoryDecorator().setDisablingAllowedWithBoolean(true)
        self.hopper!.setAllowWritesWithBoolean(false)
        self.hopper!.forMobile()
        self.hopper!.load__(with: location)
        print(self.hopper!.getStorage().getBounds())
        
    }
    
    func singleTap() {
        finishRoute()
        mapListener.delegate = nil
        map.setMapEventListener(nil)
        map.setMapEventListener(actualEventsSave)
    }
    
    func longTap() {
        // No action for long tap
    }
    
    func startRoute() {
        map.setMapEventListener(mapListener)
        mapListener.delegate = self
        routing = Routing(mapView: self.map, hopper: self.hopper)
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
    
    func onePointRoute(event: RouteMapEvent) {
        
        routing.setStopMarker(position: event.clickPosition)
    }
    
    func finishRoute(){
        routing.cleaning()
    }
    
    func showRoute(start: NTMapPos, stop: NTMapPos) {
        DispatchQueue.global().async {
            
            let response = self.routing.getResult(startPos: start, stopPos: stop)
            self.result = response.0
            let info: String! = response.1
            
            DispatchQueue.main.async(execute: {
                if (self.result == nil) {
                    self.progressLabel.complete(message: info)
                    return
                } else {
                    self.progressLabel.complete(message: self.routing.getMessage(result: self.result!))
                }
                
                let color = NTColor(r: 14, g: 122, b: 254, a: 150)
                self.routing.show(result: self.result!, lineColor: color!, complete: {
                    (route: Route) in
                    
                })
            })
        }
    }
    
    var currentRoutePoint : Int = 0
    var mDestinationArrived = false
    var mTraveledDistance: Double?
    var isTimerRunning: Bool?
    
    func updateRoute(location: CLLocation) {
        
        let speed: Double = location.speed
        var posTolerance: Float = 60.0
        
        let latitude = Double(location.coordinate.latitude)
        let longitude = Double(location.coordinate.longitude)
        let accuracy = Float(location.horizontalAccuracy)
        
        if accuracy > 0 {
            posTolerance = posTolerance / 2 + accuracy
        }
        
        let currentGeoPoint: NTMapPos = NTMapPos(x: longitude, y: latitude)
        
        var calculateRoute = false
        
        // 1. Update current route position status according to latest received location
        DispatchQueue.global().async {
            let finished : Bool = self.updateCurrentRouteStatus(location: location, posTolerance: Float(posTolerance), speed: Float(speed))
            
            DispatchQueue.main.async(execute: {
                if (finished) {
                    self.finishRoute()
                    self.locationMarker.modeFree()
                    return;
                }
            })
        }
        let pointList : PointList = (self.result?.getBest().getPoints())!
        let currentRoute = self.currentRoutePoint
        
        // 2. Analyze if we need to recalculate route
        // >100m off current route (sideways)
        
        if (currentRoute > 0) {
            
            let afterPoint: NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(currentRoute) - 1), y: pointList.getLatitudeWith(jint(currentRoute) - 1))
            let point: NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(currentRoute)), y: pointList.getLatitudeWith(jint(currentRoute)))
            
            let dist = self.getOrthogonalDistance(geoPoint: currentGeoPoint, geoFrom: afterPoint, geoTo: point);
            if (dist > Double(1.2 * posTolerance)) {
                calculateRoute = true;
            }
        }
        
        // 3. Identify wrong movement direction
        let next = self.getNextRouteGeoPoint();
        let wrongMovementDirection = self.checkWrongMovementDirection(location: location, nextRouteLocation: next);
        let point: NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(currentRoute)), y: pointList.getLatitudeWith(jint(currentRoute)))
        if (wrongMovementDirection && self.distanceBetween(startPoint: currentGeoPoint, endPoint: point) > Double(2 * posTolerance)) {
            calculateRoute = true;
        }
        
        // 4. Identify if UTurn is needed
        
        // TODO
        
        if (calculateRoute) {
            
            let finalPos: NTMapPos = NTMapPos(x: pointList.getLongitudeWith(pointList.getSize() - 1), y: pointList.getLatitudeWith(pointList.getSize() - 1))
            print(finalPos.debugDescription)
            
            let latitude = Double(location.coordinate.latitude)
            let longitude = Double(location.coordinate.longitude)
            
            let startPosition : NTMapPos = self.projection.fromWgs84(NTMapPos(x: longitude, y: latitude))
            print(startPosition.debugDescription)
            
            DispatchQueue.global().async {
                
                let response = self.routing.getNewResult(startPos: startPosition, stopPos: finalPos)
                self.result = response.0
                let info: String = response.1
                
                DispatchQueue.main.async(execute: {
                    
                    if (self.result == nil) {
                        self.progressLabel.complete(message: info)
                        return
                    } else {
                        self.progressLabel.complete(message: self.routing.getMessage(result: self.result!))
                    }
                    
                    let color = NTColor(r: 14, g: 122, b: 254, a: 150)
                    self.routing.show(result: self.result!, lineColor: color!, complete: {_ in })
                    
                    //MARK: UPDATE MARKER POSITION
                    // In navigation accurancy is not needed
                    self.locationMarker.showAt(latitude: latitude, longitude: longitude, accuracy: 0)
                    
                    //MARK: UPDATE VIEW POSITION
                    if self.isTimerRunning == false {
                        self.locationMarker.modeNavigation()
                    }

                })
            }
            
            calculateRoute = false
        } else {
            
            // 5. update path layer and instructions
            if (currentRoute > 0) {
                
                let prevLocation = NTMapPos(x: pointList.getLongitudeWith(jint(currentRoute) - 1), y: pointList.getLatitudeWith(jint(currentRoute) - 1))
                
                let project = self.getProjection(lat: currentGeoPoint.getY(), lon: currentGeoPoint.getX(), fromLat: prevLocation!.getY(), fromLon: prevLocation!.getX(), toLat: next!.getY(), toLon: next!.getX());
                
                //MARK: UPDATE MARKER POSITION
                // In navigation accurancy is not needed
                self.locationMarker.showAt(latitude: latitude, longitude: longitude, accuracy: 0)
                
                //MARK: UPDATE VIEW POSITION
                if isTimerRunning == false {
                    locationMarker.modeNavigation()
                }
                
                //MARK: UPDATING LINE
                self.routing.show(points: pointList, startPoint: project, currentPointList: self.currentRoutePoint)
            }
        }
        
    }
    
    
    func updateCurrentRouteStatus(location: CLLocation, posTolerance: Float, speed: Float) -> Bool {
        
        let pointList: PointList = self.result!.getBest().getPoints()
        var currentRoute = currentRoutePoint;
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let currentGeoPoint = NTMapPos(x: longitude, y: latitude)
        
        while (currentRoute + 1) < (pointList.size()) {
            
            let endPoint : NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(currentRoute)), y: pointList.getLatitudeWith(jint(currentRoute)))
            
            var dist = distanceBetween(startPoint: currentGeoPoint!, endPoint: endPoint);
            
            if (currentRoute > 0) {
                let afterPoint : NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(currentRoute) - 1), y: pointList.getLatitudeWith(jint(currentRoute) - 1))
                dist = getOrthogonalDistance(geoPoint: currentGeoPoint!, geoFrom: afterPoint, geoTo: endPoint)
            }
            
            var processed = false;
            // if we are still too far try to proceed many points
            // if not then look ahead only 3 in order to catch sharp turns
            let longDistance = dist >= 250;
            
            let newCurrentRoute = lookAheadFindMinOrthogonalDistance(currentLocation: currentGeoPoint!, pointList: pointList, currentRoute: currentRoute, iterations: longDistance ? 15 : 8);
            
            let newPoint : NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(newCurrentRoute)), y: pointList.getLatitudeWith(jint(newCurrentRoute)))
            let endnewPoint : NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(newCurrentRoute) + 1), y: pointList.getLatitudeWith(jint(newCurrentRoute) + 1))
            
            let newDist = getOrthogonalDistance(geoPoint: currentGeoPoint!, geoFrom: newPoint, geoTo: endnewPoint);
            
            if (longDistance) {
                if (newDist < dist) {
                    processed = true;
                }
            } else if (newDist < dist || newDist < 10) {
                // newDist < 10 (avoid distance 0 till next turn)
                if (dist > Double(posTolerance)) {
                    processed = true;
                } else {
                    // case if you are getting close to the next point after turn
                    // but you have not yet turned (could be checked bearing)
                    
                    let newPoint : NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(currentRoute)), y: pointList.getLatitudeWith(jint(currentRoute)))
                    let locationBearing = location.bearingToLocationDegrees(destinationPosition: newPoint)
                    
                    if ( locationBearing > 0) {
                        
                        let nextNewPoint : NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(newCurrentRoute) + 1), y: pointList.getLatitudeWith(jint(newCurrentRoute) + 1))
                        
                        let bearingToRoute = bearingBetween(startPoint: currentGeoPoint!, endPoint: newPoint);
                        let bearingRouteNext = bearingBetween(startPoint: newPoint, endPoint: nextNewPoint);
                        let bearingMotion = location.course;
                        let diff = abs(degreesDiff(a1: bearingMotion, a2: Double(bearingToRoute)));
                        let diffToNext = abs(degreesDiff(a1: bearingMotion, a2: Double(bearingRouteNext)));
                        if (diff > diffToNext) {
                            processed = true;
                        }
                    }
                }
            }
            
            if (processed) {
                // that node already passed
                //TODO Update next intermediate, ...
                currentRoutePoint = newCurrentRoute + 1;
                currentRoute = newCurrentRoute + 1;
            } else {
                break;
            }
        }
        
        // 3. check if destination found
        let next : NTMapPos? = getNextRouteGeoPoint();
        let project: NTMapPos?
        if (currentRoutePoint > 0 && next != nil) {
            let prevLocation = NTMapPos(x: pointList.getLongitudeWith(jint(currentRoute) - 1), y: pointList.getLatitudeWith(jint(currentRoute) - 1))
            project = getProjection(lat: (currentGeoPoint?.getY())!, lon: (currentGeoPoint?.getX())!,
                                    fromLat: (prevLocation?.getY())!, fromLon: (prevLocation?.getX())!,
                                    toLat: (next?.getY())!, toLon: (next?.getX())!);
        } else {
            project = currentGeoPoint!;
        }
        
        let lastPoint = NTMapPos(x: pointList.getLongitudeWith(jint(pointList.size()) - 1), y: pointList.getLatitudeWith(jint(pointList.size()) - 1))
        
        if (distanceBetween(startPoint: currentGeoPoint!, endPoint: lastPoint!) < 17 && !mDestinationArrived) {
            mDestinationArrived = true;
            
            return true
            
        }
        return false
    }
    
    func getNextRouteGeoPoint() -> NTMapPos? {
        let pl : PointList = (result?.getBest().getPoints())!
        if (currentRoutePoint < Int(pl.size())) {
            return NTMapPos(x: pl.getLongitudeWith(jint(currentRoutePoint)), y: pl.getLatitudeWith(jint(currentRoutePoint)))
        }
        return nil
    }
    
    func degreesDiff(a1: Double, a2: Double) -> Double {
        var diff = a1 - a2;
        while (diff > 180) {
            diff -= 360;
        }
        while (diff <= -180) {
            diff += 360;
        }
        return diff;
    }
    
    func checkWrongMovementDirection(location: CLLocation, nextRouteLocation: NTMapPos?) -> Bool {
        if (nextRouteLocation != nil) {
            let bearingMotion = location.course
            var results = [Float]()
            results = computeDistanceAndBearing(lat1: location.coordinate.latitude, lon1: location.coordinate.longitude,
                                                lat2: nextRouteLocation!.getY(), lon2: nextRouteLocation!.getX());
            let bearingToRoute = results[1];
            let diff = degreesDiff(a1: bearingMotion, a2: Double(bearingToRoute));
            
            return abs(diff) > 60;
        }
        
        return false;
    }
    
    func bearingBetween(startPoint: NTMapPos, endPoint: NTMapPos) -> Float {
        var results = [Float]()
        results = computeDistanceAndBearing(lat1: startPoint.getY(), lon1: startPoint.getX(), lat2: endPoint.getY(), lon2: endPoint.getX());
        return results[1];
    }
    
    func bearingBetween(lat1: Double , lon1: Double, lat2: Double, lon2: Double) -> Float {
        var results = [Float]()
        results = computeDistanceAndBearing(lat1: lat1, lon1: lon1, lat2: lat2, lon2: lon2);
        return results[1];
    }
    
    func getDistance(l : NTMapPos, latitude : Double, longitude : Double) -> Double {
        return getDistance(lat1: l.getY(), lon1: l.getX(), lat2: latitude, lon2: longitude);
    }
    
    func getOrthogonalDistance(lat : Double, lon : Double, fromLat : Double, fromLon : Double, toLat : Double, toLon : Double) -> Double{
        return getDistance(l: getProjection(lat: lat, lon: lon, fromLat: fromLat, fromLon: fromLon, toLat: toLat, toLon: toLon), latitude: lat, longitude: lon);
    }
    
    func getOrthogonalDistance(geoPoint : NTMapPos, geoFrom : NTMapPos, geoTo : NTMapPos) -> Double {
        return getOrthogonalDistance(lat: geoPoint.getY(), lon: geoPoint.getX(), fromLat: geoFrom.getY(), fromLon: geoFrom.getX(),
                                     toLat: geoTo.getY(), toLon: geoTo.getX());
    }
    
    func scalarMultiplication(xA: Double, yA: Double, xB: Double, yB: Double, xC: Double, yC: Double) -> Double {
        return (xB - xA) * (xC - xA) + (yB - yA) * (yC - yA);
    }
    
    func getProjection(lat : Double, lon : Double, fromLat : Double, fromLon : Double, toLat : Double, toLon : Double) -> NTMapPos{
        let mDist : Double = (fromLat - toLat) * (fromLat - toLat) + (fromLon - toLon) * (fromLon - toLon);
        let projection : Double = scalarMultiplication(xA: fromLat, yA: fromLon, xB: toLat, yB: toLon, xC: lat, yC: lon);
        var prlat : Double;
        var prlon : Double;
        if (projection < 0) {
            prlat = fromLat;
            prlon = fromLon;
        } else if (projection >= mDist) {
            prlat = toLat;
            prlon = toLon;
        } else {
            prlat = fromLat + (toLat - fromLat) * (projection / mDist);
            prlon = fromLon + (toLon - fromLon) * (projection / mDist);
        }
        return NTMapPos(x: prlon, y: prlat)
    }
    
    func distanceBetween(startPoint : NTMapPos, endPoint : NTMapPos) -> Double{
        var results = [Float]()
        
        results = computeDistanceAndBearing(lat1: startPoint.getY(), lon1: startPoint.getX(), lat2: endPoint.getY(), lon2: endPoint.getX());
        
        return Double(results[0]);
    }
    
    func getDistance(lat1 : Double, lon1 : Double, lat2 : Double, lon2 : Double) -> Double {
        let R : Double = 6372.8; // for haversine use R = 6372.8 km instead of 6371 km
        let dLat : Double = Double((lat2 - lat1).toRadians)
        let dLon : Double = Double((lon2 - lon1).toRadians)
        let a : Double = sin(dLat / 2) * sin(dLat / 2) + cos(Double((lat1).toRadians)) * cos(Double((lat2).toRadians)) * sin(dLon / 2) * sin(dLon / 2)
        //double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        //return R * c * 1000;
        // simplyfy haversine:
        return (2 * R * 1000 * asin(sqrt(a)));
    }
    
    func computeDistanceAndBearing(lat1: Double, lon1: Double,
                                   lat2 : Double, lon2 : Double) -> [Float]{
        var results: [Float] = [0,0,0]
        // Based on http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
        // using the "Inverse Formula" (section 4)
        let osmandDist : Float = Float(getDistance(lat1: lat1, lon1: lon1, lat2: lat2, lon2: lon2));
        let MAXITERS = 20;
        // Convert lat/long to radians
        let lat11 = lat1 * .pi / 180.0;
        let lat22 = lat2 * .pi / 180.0;
        let lon11 = lon1 * .pi / 180.0;
        let lon22 = lon2 * .pi / 180.0;
        
        let a = 6378137.0; // WGS84 major axis
        let b = 6356752.3142; // WGS84 semi-major axis
        let f = (a - b) / a;
        let aSqMinusBSqOverBSq = (a * a - b * b) / (b * b);
        
        let L = lon22 - lon11;
        var A = 0.0;
        let U1 = atan((1.0 - f) * tan(lat11));
        let U2 = atan((1.0 - f) * tan(lat22));
        
        let cosU1 = cos(U1);
        let cosU2 = cos(U2);
        let sinU1 = sin(U1);
        let sinU2 = sin(U2);
        let cosU1cosU2 = cosU1 * cosU2;
        let sinU1sinU2 = sinU1 * sinU2;
        
        var sigma: Double = 0.0;
        var deltaSigma: Double = 0.0;
        var cosSqAlpha: Double;
        var cos2SM: Double;
        var cosSigma: Double;
        var sinSigma: Double;
        var cosLambda: Double = 0.0;
        var sinLambda: Double = 0.0;
        
        var lambda = L; // initial guess
        
        for  _ in 0 ..< MAXITERS {
            let lambdaOrig = lambda;
            cosLambda = cos(lambda);
            sinLambda = sin(lambda);
            let t1 = cosU2 * sinLambda;
            let t2 = cosU1 * sinU2 - sinU1 * cosU2 * cosLambda;
            let sinSqSigma = t1 * t1 + t2 * t2; // (14)
            sinSigma = sqrt(sinSqSigma);
            cosSigma = sinU1sinU2 + cosU1cosU2 * cosLambda; // (15)
            sigma = atan2(sinSigma, cosSigma); // (16)
            let sinAlpha = (sinSigma == 0) ? 0.0 :
                cosU1cosU2 * sinLambda / sinSigma; // (17)
            cosSqAlpha = 1.0 - sinAlpha * sinAlpha;
            cos2SM = (cosSqAlpha == 0) ? 0.0 :
                cosSigma - 2.0 * sinU1sinU2 / cosSqAlpha; // (18)
            
            let uSquared = cosSqAlpha * aSqMinusBSqOverBSq; // defn
            A = 1 + (uSquared / 16384.0) * // (3)
                (4096.0 + uSquared *
                    (-768 + uSquared * (320.0 - 175.0 * uSquared)));
            let B = (uSquared / 1024.0) * // (4)
                (256.0 + uSquared *
                    (-128.0 + uSquared * (74.0 - 47.0 * uSquared)));
            let C = (f / 16.0) *
                cosSqAlpha *
                (4.0 + f * (4.0 - 3.0 * cosSqAlpha)); // (10)
            let cos2SMSq = cos2SM * cos2SM;
            deltaSigma = B * sinSigma * // (6)
                (cos2SM + (B / 4.0) *
                    (cosSigma * (-1.0 + 2.0 * cos2SMSq) -
                        (B / 6.0) * cos2SM *
                        (-3.0 + 4.0 * sinSigma * sinSigma) *
                        (-3.0 + 4.0 * cos2SMSq)));
            
            lambda = L +
                (1.0 - C) * f * sinAlpha *
                (sigma + C * sinSigma *
                    (cos2SM + C * cosSigma *
                        (-1.0 + 2.0 * cos2SM * cos2SM))); // (11)
            
            let delta = (lambda - lambdaOrig) / lambda;
            if (abs(delta) < 1.0e-12) {
                break;
            }
        }
        
        let distance = Float(b * A * (sigma - deltaSigma));
        results.insert(distance, at: 0)
        
        if (results.count > 1) {
            var initialBearing = Float(atan2(cosU2 * sinLambda,
                                             cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
            initialBearing *= 180.0 / .pi;
            results.insert(initialBearing, at: 1)
            if (results.count > 2) {
                var finalBearing = Float(atan2(cosU1 * sinLambda,
                                               -sinU1 * cosU2 + cosU1 * sinU2 * cosLambda));
                finalBearing *= 180.0 / .pi;
                results.insert(finalBearing, at: 2)
            }
        }
        // Should we leave only for 4.2.1? Or keep consistent for all devices?
        results[0] = osmandDist;
        return results
    }
    
    func lookAheadFindMinOrthogonalDistance(currentLocation: NTMapPos, pointList: PointList, currentRoute: Int, iterations: Int) -> Int {
        var newDist: Double;
        var dist = Double.infinity
        var index = currentRoute;
        var lcurrentRoute = currentRoute
        var literations = iterations
        while (iterations > 0 && lcurrentRoute + 1 < pointList.size()) {
            let afterPoint : NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(lcurrentRoute)), y: pointList.getLatitudeWith(jint(lcurrentRoute)))
            let endPoint : NTMapPos = NTMapPos(x: pointList.getLongitudeWith(jint(lcurrentRoute) + 1), y: pointList.getLatitudeWith(jint(lcurrentRoute) + 1))
            newDist = getOrthogonalDistance(geoPoint: currentLocation,  geoFrom: afterPoint, geoTo: endPoint);
            
            if (newDist < dist) {
                index = lcurrentRoute;
                dist = newDist;
            }
            lcurrentRoute+=1;
            literations-=1;
        }
        return index;
    }
    
}
