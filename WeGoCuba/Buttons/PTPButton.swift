//
//  PTPButton.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/13/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class PTPButton : UIButton {
    
    var delegate: PTPButtonDelegate?
    
    func addRecognizer() {
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchChanged(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func switchChanged(_ sender: UITapGestureRecognizer) {
        delegate?.ptpButtonTapped()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = min(bounds.width,bounds.height) / 2.0
    }
    
}


protocol PTPButtonDelegate {
    func ptpButtonTapped()
}
