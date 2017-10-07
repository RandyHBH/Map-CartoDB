//
//  RouteButton.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/3/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

class RouteButton : SwitchButton {
    
    var delegate: RouteButtonDelegate?
    
    
    func initialize(onImageUrl: String, offImageUrl: String) {
        
        onImage = UIImage(named: onImageUrl)
        offImage = UIImage(named: offImageUrl)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchChanged(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func switchChanged(_ sender: UITapGestureRecognizer) {
        toggle()
        delegate?.routeSwitchTapped()
    }
    
}


protocol RouteButtonDelegate {
    func routeSwitchTapped()
}
