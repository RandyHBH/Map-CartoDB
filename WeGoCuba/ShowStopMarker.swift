//
//  ShowStopMarker.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/26/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class ShowStopMarker: UIView {
    
    // distanceType and unitMesure NEED TO BE GLOBAL, MAYBE IN THE SINGLETON
    var distanceType: DistanceType = .km
    var unitMesure: UnitMesure = .km
    
    var actualStopMarker: NTMapPos!
    var delegate: ShowStopMarkerDelegate?

    @IBOutlet weak var distanceToMarker: UILabel!

    override func awakeFromNib() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showStopMarkerTapped(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func updateDistance(pos1Wgs: NTMapPos, finalPos: NTMapPos) -> Void {
        self.actualStopMarker = finalPos
        distanceToMarker.text = distanceConvert(distance: getDistance(pos1Wgs: pos1Wgs, pos2Wgs: finalPos)) + " " + distanceType.rawValue
    }
    
    func showStopMarkerTapped(_ sender: UITapGestureRecognizer) {
        delegate?.showStopMarker(pos: actualStopMarker)
    }
    
    private func getDistance(pos1Wgs: NTMapPos, pos2Wgs: NTMapPos) -> Double {
        // Calculate distance with haversine formula
        // https://en.wikipedia.org/wiki/Haversine_formula
        
        let latDistance = (pos1Wgs.getY() - pos2Wgs.getY()).toRadians
        let lonDistance = (pos1Wgs.getX() - pos2Wgs.getX()).toRadians
        
        let AVERAGE_RADIUS_OF_EARTH = 6378137.0;
        
        let a =
            sin(latDistance / 2.0) * sin(latDistance / 2.0) +
                cos(pos1Wgs.getY().toRadians) * cos(pos2Wgs.getY().toRadians) *
                sin(lonDistance / 2.0) * sin(lonDistance / 2.0)
        
        let c = Double(2.0 * atan2(sqrt(a), sqrt(1.0 - a)))
        
        // Total distance shown by the MapView
        let distanceMeters = AVERAGE_RADIUS_OF_EARTH * c
        
        return distanceMeters
    }
    
    private func distanceConvert(distance: Double) -> String {
        if (unitMesure == .km) {
            switch distance {
            case 0:
                distanceType = .m
                return "\(distance)"
            case 1..<1000:
                distanceType = .m
                return "\(round(distance * 100) / 100)"
            default:
                distanceType = .km
                let distance = round(distance / 1000 * 100) / 100
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
}

protocol ShowStopMarkerDelegate {
    func showStopMarker(pos: NTMapPos)
}
