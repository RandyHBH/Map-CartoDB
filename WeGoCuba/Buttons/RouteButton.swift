//
//  RouteButton.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/3/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class RouteButton : UIButton {
    
    var delegate: RouteButtonDelegate?
    
    func addRecognizer() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchChanged(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func switchChanged(_ sender: UITapGestureRecognizer) {
        delegate?.routeButtonTapped()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        layer.cornerRadius = min(bounds.width,bounds.height) / 2.0
    }
    
}


protocol RouteButtonDelegate {
    func routeButtonTapped()
}
