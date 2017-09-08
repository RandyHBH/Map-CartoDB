//
//  AddMarkers.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 9/7/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

extension NTMapView {
    
    func emptyPositionMarker(projection: NTProjection) -> NTMarker {
        
        let source = NTLocalVectorDataSource(projection: projection);
        
        let layer = NTVectorLayer(dataSource: source);
        
        self.getLayers().add(layer);

        let builder = NTMarkerStyleBuilder();
        
        var colors = [
            NTColor(r: 255, g: 255, b: 255, a: 255),
            NTColor(r: 0, g: 0, b: 255, a: 255),
            NTColor(r: 255, g: 0, b: 0, a: 255),
            NTColor(r: 0, g: 255, b: 0, a: 255),
            NTColor(r: 0, g: 0, b: 0, a: 255),
            ];
        
        let color = colors[Int(arc4random_uniform(4))];
        
        builder?.setSize(15);
        builder?.setColor(color);
        
        // Create a marker style, we use default marker bitmap here
        let style = builder?.buildStyle()
        
        let marker = NTMarker.init(pos: NTMapPos.init(), style: style)
        
        source?.add(marker);
        
        return marker!;
    }
}
