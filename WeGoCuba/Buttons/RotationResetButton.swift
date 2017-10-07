//
//  Compass.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 18/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class RotationResetButton: PopupButton {

    let url = "icon_compass.png"
    
    var isInitialized = false
    
    override func layoutSubviews() {
        
        // CGAffineTransform calls layoutSubviews and that causes the image to behave in weird ways
        // Simply do not call this again if it's been initialized with a frame
        if (!isInitialized) {
            if (frame.width > 0) {
                isInitialized = true
                super.layoutSubviews()
            }
        }
    }
    
    func rotate(angle: CGFloat) {
        imageView?.transform = CGAffineTransform(rotationAngle: angle.degreesToRadians)
    }
    
    var resetDuration: Float = 0
    
    func reset() {
        UIView.animate(withDuration: TimeInterval(resetDuration), animations: {
            self.imageView?.transform = CGAffineTransform.identity
            self.imageView?.image = UIImage(named: self.url)
        })
    }
    
}
