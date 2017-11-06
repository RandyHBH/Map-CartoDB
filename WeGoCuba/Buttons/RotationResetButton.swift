//
//  Compass.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 18/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class RotationResetButton: UIButton {

    let url = "icon_compass.png"
    
    var isInitialized = false
    
    override func layoutSubviews() {
        
        // CGAffineTransform calls layoutSubviews and that causes the image to behave in weird ways
        // Simply do not call this again if it's been initialized with a frame
        if (!isInitialized) {
            if (frame.width > 0) {
                isInitialized = true
                super.layoutSubviews()
                backgroundColor = UIColor.white
                
                imageView!.clipsToBounds = true
                imageView!.contentMode = .scaleAspectFit
                layer.cornerRadius = min(bounds.width,bounds.height) / 2.0
                
                let padding: CGFloat = frame.height / 3.5
                
                imageView?.frame = CGRect(x: padding, y: padding, width: frame.width - 2 * padding, height: frame.height - 2 * padding)
                
                addRoundShadow()
                
                alpha = 0.8
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (!isEnabled) {
            return
        }
        
        alpha = 0.8
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (!isEnabled) {
            return
        }
        
        alpha = 0.8
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
