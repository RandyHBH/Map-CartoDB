//
//  DestinationListener.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/9/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

class DestinationClickListener: NTMapEventListener {
    
    var delegate: DestinationDelegate?
    
    var destination: NTMapPos!
    
    override func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        
        if (mapClickInfo.getClickType() != NTClickType.CLICK_TYPE_LONG) {
            // Only listen to long clicks
            return
        }
        
        let position = mapClickInfo.getClickPos()
        destination = position
        
         delegate?.destinationSet(position: destination)
    }
    
}

protocol DestinationDelegate {
    
    func destinationSet(position: NTMapPos)
}
