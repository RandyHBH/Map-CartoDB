//
//  LocationButton.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/3/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class LocationButton: UIButton {
    
     var delegate: LocationButtonDelegate?
    
    func addRecognizer() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchChanged(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func switchChanged(_ sender: UITapGestureRecognizer) {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       layer.cornerRadius = min(bounds.width,bounds.height) / 2.0
    }
    
    
}

protocol LocationButtonDelegate {
    func locationSwitchTapped()
}
