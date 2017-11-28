//
//  BaseMap.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/9/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation


class BaseMap: NSObject {
    
    var map : NTMapView!
    var source: NTTileDataSource!
    
    let name: String = "cuba"
    let format : String = "mbtiles"
    
    init(mapView : NTMapView) {
        super.init()
        
        self.map = mapView
        
        self.source = createTileDataSource()
        loadVectorDataSource(source: source)
    }
    

    func loadVectorDataSource(source : NTTileDataSource) {
       
        let newbaseLayer = NTCartoOfflineVectorTileLayer(dataSource: source, style: .CARTO_BASEMAP_STYLE_VOYAGER)
        
        map.getLayers().insert(0, layer: newbaseLayer)
        
        let decoder = newbaseLayer?.getTileDecoder() as! NTMBVectorTileDecoder
        decoder.setStyleParameter("buildings", value: "2")
    }
    
    func createTileDataSource() -> NTTileDataSource {

        // file-based local offline datasource
        let path: String? = Bundle.main.path(forResource: name, ofType: format)
        
        let vectorTileDataSource: NTTileDataSource? = NTMBTilesTileDataSource(minZoom: 0, maxZoom: 14, path: path)
        
        return vectorTileDataSource!
    }
    
}
