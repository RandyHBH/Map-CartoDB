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

    var image: UIImage!
    
    func initialize(imageUrl: String) {
        backgroundColor = UIColor.white
        
        imageView?.clipsToBounds = true
        imageView?.contentMode = .scaleAspectFit
        
        image = UIImage(named: imageUrl)
        imageView?.image = image
        
    }
    
    override func layoutSubviews() {

        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 2
        
        let padding: CGFloat = frame.height / 3.5
        
        imageView?.frame = CGRect(x: padding, y: padding, width: frame.width - 2 * padding, height: frame.height - 2 * padding)
        
        addRoundShadow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        alpha = 0.5
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (!isEnabled) {
            return
        }
        
        alpha = 1.0
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (!isEnabled) {
            return
        }
        
        alpha = 1.0
    }
    
}



