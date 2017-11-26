//
//  Routing.swift
//  AdvancedMap.Swift
//
//  Created by Aare Undo on 22/06/2017.
//  Copyright © 2017 CARTO. All rights reserved.
//

import Foundation

class Routing {
    
    var hopper: GraphHopper?
    
    var startMarker, stopMarker: NTMarker?
    var instructionUp, instructionLeft, instructionRight: NTMarkerStyle?
    
    var routeDataSource, routeStartStopDataSource: NTLocalVectorDataSource?
    
    var mapView: NTMapView!
    var projection: NTProjection!
    
    var showTurns: Bool = false
    
    init(mapView: NTMapView, hopper: GraphHopper) {
        
        self.mapView = mapView
        self.hopper = hopper
        projection = mapView.getOptions().getBaseProjection()
        
        let start = NTBitmapFromString(path: "ic_flag_green")
        let stop = NTBitmapFromString(path: "ic_flag_red")
        
        // Define layer and datasource for route line and instructions
        routeDataSource = NTLocalVectorDataSource(projection: projection)
        let routeLayer = NTVectorLayer(dataSource: routeDataSource)
        mapView.getLayers().add(routeLayer)
        
        // Define layer and datasource for route start and stop markers
        routeStartStopDataSource = NTLocalVectorDataSource(projection: projection)
        let vectorLayer = NTVectorLayer(dataSource: routeStartStopDataSource)
        mapView.getLayers().add(vectorLayer)
        
        // Set visible zoom range for the vector layer
        vectorLayer?.setVisibleZoom(NTMapRange(min: 0, max: 24))
        
        let markerBuilder = NTMarkerStyleBuilder()
        markerBuilder?.setBitmap(start)
        markerBuilder?.setHideIfOverlapped(false)
        markerBuilder?.setSize(20)
        
        let defaultPosition = NTMapPos(x: 0, y: 0)
        startMarker = NTMarker(pos: defaultPosition, style: markerBuilder?.buildStyle())
        startMarker?.setVisible(false)
        
        routeStartStopDataSource?.add(startMarker)
        
        markerBuilder?.setBitmap(stop)
        stopMarker = NTMarker(pos: defaultPosition, style: markerBuilder?.buildStyle())
        stopMarker?.setVisible(false)
        
        routeStartStopDataSource?.add(stopMarker)
        
    }
    
    func NTBitmapFromString(path: String) -> NTBitmap {
        let image = UIImage(named: path)
        return NTBitmapUtils.createBitmap(from: image)
    }
    
    /*
     * Return Route Model on complete so we have all info
     */
    func show(result: GHResponse, lineColor: NTColor, complete: (_ route: Route) -> Void) {
        routeDataSource?.clear()
        
        let lines = createPolyLine(result: result, color: lineColor)
        routeDataSource?.add(lines[0])
        routeDataSource?.add(lines[1])
        
        let path : PathWrapper = result.getBest()
        let instructions : InstructionList = path.getInstructions()
        
        let count = instructions.size()
        
        let vector = NTMapPosVector()
        
        for i in stride(from: 0, to: count, by: 1) {
            
            let instruction : Instruction = instructions.getWith(i)
            let xLongitud = instruction.getFirstLon()
            let yLatitud = instruction.getFirstLat()
            
            let position = projection.fromWgs84(NTMapPos(x: xLongitud, y: yLatitud))
            
            vector?.add(position)
        }
        
         let polygon = NTPolygon(poses: vector, style: NTPolygonStyleBuilder().buildStyle())
        
        var route = Route()
        
        route = getRouteInfo(result: result)
        route.bounds = polygon?.getBounds()
        
        complete(route)
    }
    
    // TODO: OBTNER TODA LA INFO QUE SE QUIERE MOSTRAR
    // - DISTANCIA
    // - TIEMP
    fileprivate func getRouteInfo(result: GHResponse) -> Route {
        
        let routeInfo = Route()
        let path : PathWrapper = result.getBest()
        
        routeInfo.distance = path.getDistance()
        let miliToSeconds = Int(path.getTime())/1000
        routeInfo.durationTimeInSeconds = miliToSeconds
 
        return routeInfo
    }
    
    func getResult(startPos: NTMapPos, stopPos: NTMapPos, vehicle: String) -> (GHResponse?,String) {
        
        let routeMode = DataContainer.instance.selectedRouteModeOption!
        
        var result: GHResponse?
        let request : GHRequest!
        
        let longitudStart84 = projection.toWgs84(startPos).getX()
        let latitudStart84 = projection.toWgs84(startPos).getY()
        
        let longitudStop84 = projection.toWgs84(stopPos).getX()
        let latitudStop84 = projection.toWgs84(stopPos).getY()
        
        
        request = GHRequest(double: latitudStart84, with: longitudStart84, with: latitudStop84, with: longitudStop84)
        request.getHints().put(with: "ch.disable", withId: "true")
        request.setVehicleWith(vehicle)
        
        if routeMode == .corta {
            request.setWeightingWith("shortest")
        } else {
            request.setWeightingWith("fastest")
        }
        
        request.setLocaleWith("es")
        
        result = self.hopper?.route(with: request)
        
        var routeInfo : String = ""
        
        if (result?.hasErrors())! {
            
            routeInfo = routeInfo + ("\(result?.getErrors())\n")
            return (nil, routeInfo)
        }
        
        return (result,"")
        
    }
    
    func createPolyLine(result: GHResponse, color: NTColor) -> [NTLine] {
        
        let builder = NTLineStyleBuilder()
        builder?.setColor(color)
        builder?.setWidth(7)
        
        let builderArrow = NTLineStyleBuilder()
        builderArrow?.setColor(color)
        builderArrow?.setBitmap(NTBitmapFromString(path: "ic_go_ahead"))
        builderArrow?.setWidth(5)
        
        let points = result.getBest().getPoints()!
        let size = points.size()
        let linePoses = NTMapPosVector()
        
        var i : jint = 0
        while i < size {
            linePoses?.add(projection.fromWgs84(NTMapPos(x: points.getLongitudeWith(i), y: points.getLatitudeWith(i))))
            i += 1
        }
        
        return [NTLine(poses: linePoses, style: builder?.buildStyle()), NTLine(poses: linePoses, style: builderArrow?.buildStyle())]
    }
    
    func show(points: PointList, startPoint: NTMapPos, currentPointList : Int) {
        routeDataSource?.clear()
//        startMarker?.setVisible(true)
        
        let lines = updatePolyLine(points: points, startPoint: startPoint, currentPointList: currentPointList)
        
        routeDataSource?.add(lines[0])
        routeDataSource?.add(lines[1])
        
    }
    
    func updatePolyLine(points: PointList, startPoint: NTMapPos, currentPointList : Int) -> [NTLine] {
        
        let color = NTColor(r: 14, g: 122, b: 254, a: 150)
        let builder = NTLineStyleBuilder()
        builder?.setColor(color)
        builder?.setWidth(7)
        
        let builderArrow = NTLineStyleBuilder()
        builderArrow?.setColor(color)
        builderArrow?.setBitmap(NTBitmapFromString(path: "ic_go_ahead"))
        builderArrow?.setWidth(5)
        
        let size = points.size()
        let linePoses = NTMapPosVector()
        
        linePoses?.add(projection.fromWgs84(startPoint))
        
        var i = jint(currentPointList)
        while i < size {
            
            linePoses?.add(projection.fromWgs84(NTMapPos(x: points.getLongitudeWith(i), y: points.getLatitudeWith(i))))
            i += 1
        }
        
        return [NTLine(poses: linePoses, style: builder?.buildStyle()), NTLine(poses: linePoses, style: builderArrow?.buildStyle())]
        
    }

    func setStartMarker(position: NTMapPos) {
//        routeDataSource?.clear()
//        stopMarker?.setVisible(false)
        startMarker?.setPos(position)
        startMarker?.setVisible(true)
    }
    
    func setStopMarker(position: NTMapPos) {
        
        stopMarker?.setPos(position)
        stopMarker?.setVisible(true)
    }
    
    func cleaning() {
        
        routeDataSource?.clear()
        stopMarker?.setVisible(false)
        startMarker?.setVisible(false)
    }
}





