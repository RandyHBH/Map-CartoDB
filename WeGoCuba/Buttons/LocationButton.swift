//
//  LocationButton.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/3/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

@IBDesignable
class LocationButton: UIButton {
    
     var delegate: LocationButtonDelegate?
    
    func addRecognizer() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchChanged(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func switchChanged(_ sender: UITapGestureRecognizer) {
        toggle()
        delegate?.locationSwitchTapped()
    }
    
    var active : Bool = true
    
    func isActive() -> Bool {
        return active
    }
    
    func toggle() {
        if (active) {
            active = false
            
        } else {
            active = true
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
    
}

protocol LocationButtonDelegate {
    func locationSwitchTapped()
}
