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
    
    var delegate: SwitchDelegate?
    
    func isOnline() -> Bool {
        return imageView!.image == image
    }
    
    var offImage: UIImage!
    
    func initialize(onImageUrl: String, offImageUrl: String) {
        
        initialize(imageUrl: onImageUrl)
        offImage = UIImage(named: offImageUrl)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchChanged(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func switchChanged(_ sender: UITapGestureRecognizer) {
        toggle()
        delegate?.switchChanged()
    }
    
    func toggle() {
        if (imageView?.image == image) {
            imageView?.image = offImage
        } else {
            imageView?.image = image
        }
    }
    
}
