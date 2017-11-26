//
//  Route.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/16/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

class Route {
    
    var startPos: NTMapPos?
    var endPos: NTMapPos?
    
    var bearing: CGFloat {
        
        let lat1 = startPos!.getY().degreesToRadians
        let lon1 = startPos!.getX().degreesToRadians
        
        
        let lat2 = endPos!.getY().degreesToRadians
        let lon2 = endPos!.getX().degreesToRadians
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return CGFloat(radiansBearing).radiansToDegrees
    }
    
    var bounds: NTMapBounds?
    
    var unitMesure: UnitMesure = .km
    
    var distance: Double = 0
    var distanceType: DistanceType = .km
    var ditanceToString: String {
        return distanceConvert(distance: self.distance)
    }
    
    var distanceTraveled: Double = 0
    var distanceToTravelType: DistanceType = .km
    var distanceToTravel: String {
        return distanceConvert(distance: (distance - distanceTraveled))
    }
    
    private func distanceConvert(distance: Double) -> String {
        if (unitMesure == .km) {
            switch distance {
            case 0:
                distanceType = .m
                return "\(distance)"
            case 1..<1000:
                distanceType = .m
                return "\(round( self.distance * 100) / 100)"
            default:
                distanceType = .km
                let distance = round( self.distance / 1000 * 100) / 100
                return "\(distance)"
            }
        } else {
            let pie = 3.28084
            let milla = 0.000621371
            let tempDistance = distance * pie
            
            switch tempDistance {
            case 0:
                distanceType = .ft
                return "\(tempDistance)"
            case 1..<5280:
                distanceType = .ft
                return "\(tempDistance)"
            default:
                distanceType = .mi
                return "\(tempDistance * milla)"
            }
        }
    }
    
    var durationTimeInSeconds: Int = 0
    var durationTimeToString: String {
        let time = secondsToHoursMinutesSeconds(seconds: Int(durationTimeInSeconds))
        switch time {
        case let (h,m,_) where h > 0:
            return "\(h):\(m) h"
        case let (h,m,s) where h == 0 && m > 0:
            return "\(m):\(s) m"
        case let (h,m,s) where h == 0 && m == 0 && s >= 10:
            return "\(m):\(s) s"
        case let (h,m,s) where h == 0 && m == 0 && 0 < s && s < 10:
            return "\(m):0\(s) s"
        default:
            return "0:0"
        }
        
    }
    var arribeTime: String {
        get {
            let time = secondsToHoursMinutesSeconds(seconds: Int(durationTimeInSeconds))
            
            let date = Date()
            let calendar = Calendar.current
            
            let hour = calendar.component(.hour, from: date) + time.0
            let minutes = calendar.component(.minute, from: date) + time.1
            
            return "\(hour):\(minutes)"
        }
    }
    
    fileprivate func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    var velocity: Double = 0
    
    var velocityToString: String {
        get {
            return "\(velocity)"
        }
    }
}

enum UnitMesure: String {
    case km = "km/m"
    case milla = "mi/ft"
}
enum DistanceType: String {
    case km = "km"
    case m = "m"
    case mi = "mi"
    case ft = "ft"
}
