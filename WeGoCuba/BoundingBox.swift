//
//  BoundingBox.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 9/13/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation


class BoundingBox: NSObject {
    
    var minLat: Double = 0.0
    var minLon: Double = 0.0
    var maxLat: Double = 0.0
    var maxLon: Double = 0.0
    
    init(minLat: Double, minLon: Double, maxLat:Double, maxLon: Double) {
        self.minLat = minLat
        self.minLon = minLon
        self.maxLat = maxLat
        self.maxLon = maxLon
    }
    
    func getCenter() -> NTMapPos {
        let x: Double = (maxLon + minLon) / 2
        let y: Double = (maxLat + minLat) / 2
        return NTMapPos(x: x, y: y)
    }
    
    func toString() -> String! {
        let minLat = String(format: "%.04f", self.minLat)
        let minLon = String(format: "%.04f", self.minLon)
        let maxLat = String(format: "%.04f", self.maxLat)
        let maxLon = String(format: "%.04f", self.maxLon)
        return "bbox(" + (minLon) + (",") + (minLat) + (",") + (maxLon) + (",") + (maxLat) + (")")
    }
}
