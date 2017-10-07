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
    var marker: NTMarker?
    var map: NTBaseMapView?
    
    var tempMarker: NTMarker?
    var tempPosition: NTMapPos?
    
    convenience init(marker: NTMarker)
    {
        self.init();
        self.marker = marker;
    }
    
    
    override public func onMapClicked(_ mapClickInfo: NTMapClickInfo!) {
        
        switch mapClickInfo.getClickType() {
        case .CLICK_TYPE_LONG:
            marker?.setPos(mapClickInfo.getClickPos())
            tempMarker = marker
            tempPosition = mapClickInfo.getClickPos()
        default:
            //TODO Verificar si en la posicion existe un macador para
            //1- guardarlo o hacer cualquier otra accion
            //2- si no hay nada se elimina el marcador puesto si existe alguno
            if mapClickInfo.getClickType() == .CLICK_TYPE_SINGLE,
                mapClickInfo.getClickPos() == tempPosition{
                //TODO hacer algo
            } else {
                //Eliminar marcador y limpiar los temp*
                marker = NTMarker()
                tempMarker = marker
                tempPosition = NTMapPos()
            }
            
        }
        
    }
    
    
}

