//
//  PopupButton.swift
//  Feature Demo
//
//  Created by Aare Undo on 19/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation
import UIKit

class PopupButton : UIButton {
    
    let duration: Double = 200
    
    
    override func layoutSubviews() {

        super.layoutSubviews() 
        
    }

    func enable() {
        isEnabled = true
        alpha = 1.0
    }
    
    func disable() {
        isEnabled = false
        alpha = 0.5
    }
    
}



