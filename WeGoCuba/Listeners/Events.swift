//
//  Events.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 9/7/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

public class Events : NTMapEventListener
{
    var marker: NTMarker?;
    
    convenience init(marker: NTMarker)
    {
        self.init();
        self.marker = marker;
    }
    
    override public func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        
        marker?.setPos(mapClickInfo.getClickPos())
        
    }
    
}

