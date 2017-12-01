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
    
    var currentLayer: NTTileLayer!
    
    init(mapView : NTMapView) {
        super.init()
        
        self.map = mapView
        
        self.source = createTileDataSource()
        currentLayer = addBaseLayer(source: source)
    }
    

    func addBaseLayer(source : NTTileDataSource) -> NTCartoOfflineVectorTileLayer {
        let baseLayer = NTCartoOfflineVectorTileLayer(dataSource: source, style: .CARTO_BASEMAP_STYLE_VOYAGER)
        baseLayer?.setPreloading(true)
        map.getLayers().add(baseLayer)
        
        // Set building in 3d could be a global variable so de user can tweak how would liket to see the buildings
        let decoder = baseLayer?.getTileDecoder() as! NTMBVectorTileDecoder
        decoder.setStyleParameter("buildings", value: "2")
        
        return baseLayer!
    }
    
    func createTileDataSource() -> NTTileDataSource {

        // file-based local offline datasource
        let path: String? = Bundle.main.path(forResource: name, ofType: format)
        
        let vectorTileDataSource: NTTileDataSource? = NTMBTilesTileDataSource(minZoom: 0, maxZoom: 14, path: path)
        
        return vectorTileDataSource!
    }
    
}
