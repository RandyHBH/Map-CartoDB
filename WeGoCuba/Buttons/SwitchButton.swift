//
//  SwitchButton.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 18/07/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class SwitchButton : PopupButton {
    
    var onImage: UIImage!
    var offImage: UIImage!
    
    var active : Bool = false
    
    func isActive() -> Bool {
        return active
    }
    
    func toggle() {
        if (active) {
            active = false
            imageView?.image = offImage
        } else {
            active = true
            imageView?.image = onImage
        }
    }
    
}

