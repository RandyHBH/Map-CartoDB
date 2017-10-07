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
    
    var showTurns: Bool = true
    
    init(mapView: NTMapView) {
        
        initGraphhoper()
        
        self.mapView = mapView
        projection = mapView.getOptions().getBaseProjection()
        
        let start = NTBitmapFromString(path: "icon_pin_red.png")
        let stop = NTBitmapFromString(path: "icon_pin_red.png")
        
        let up = NTBitmapFromString(path: "direction_up.png")
        let upleft = NTBitmapFromString(path: "direction_upthenleft.png")
        let upright = NTBitmapFromString(path: "direction_upthenright")
        
        // Define layer and datasource for route line and instructions
        routeDataSource = NTLocalVectorDataSource(projection: projection)
        let routeLayer = NTVectorLayer(dataSource: routeDataSource)
        mapView.getLayers().add(routeLayer)
        
        // Define layer and datasource for route start and stop markers
        routeStartStopDataSource = NTLocalVectorDataSource(projection: projection)
        let vectorLayer = NTVectorLayer(dataSource: routeStartStopDataSource)
        mapView.getLayers().add(vectorLayer)
        
        // Set visible zoom range for the vector layer
        vectorLayer?.setVisibleZoom(NTMapRange(min: 0, max: 22))
        
        let markerBuilder = NTMarkerStyleBuilder()
        markerBuilder?.setBitmap(start)
        markerBuilder?.setHideIfOverlapped(false)
        // Note: When setting the size on Android, you need to account for Resources.DisplayMetrics.Density
        markerBuilder?.setSize(15)
        
        let defaultPosition = NTMapPos(x: 0, y: 0)
        startMarker = NTMarker(pos: defaultPosition, style: markerBuilder?.buildStyle())
        startMarker?.setVisible(false)
        
        routeStartStopDataSource?.add(startMarker)
        
        markerBuilder?.setBitmap(stop)
        stopMarker = NTMarker(pos: defaultPosition, style: markerBuilder?.buildStyle())
        stopMarker?.setVisible(false)
        
        routeStartStopDataSource?.add(stopMarker)
        
        markerBuilder?.setBitmap(up)
        instructionUp = markerBuilder?.buildStyle()
        
        markerBuilder?.setBitmap(upleft)
        instructionLeft = markerBuilder?.buildStyle()
        
        markerBuilder?.setBitmap(upright)
        instructionRight = markerBuilder?.buildStyle()
    }
    
    func NTBitmapFromString(path: String) -> NTBitmap {
        let image = UIImage(named: path)
        return NTBitmapUtils.createBitmap(from: image)
    }
    
    /*
     * Return bounds on complete so we can start downloading the BBOX
     */
    func show(result: GHResponse, lineColor: NTColor, complete: (_ route: Route) -> Void) {
        routeDataSource?.clear()
        startMarker?.setVisible(true)
        
        let line = createPolyLine(result: result, color: lineColor)
        routeDataSource?.add(line)
        
        let path : PathWrapper = result.getBest()
        let instructions : InstructionList = path.getInstructions()
        
        let vector = NTMapPosVector()
        
        let count = instructions.size()
        for i in stride(from: 0, to: count, by: 1) {

            let instruction : Instruction = instructions.getWith(i)
            
            let xLatitud = instruction.getPoints().getLatitudeWith(i)
            let yLongitud = instruction.getPoints().getLongitudeWith(i)
            
            let position = NTMapPos(x: xLatitud, y: yLongitud)
            
            if (showTurns) {
                createRoutePoint(position: position!, instruction: instruction, source: routeDataSource!)
            }
            
            vector?.add(position)
        }
        
        let polygon = NTPolygon(poses: vector, style: NTPolygonStyleBuilder().buildStyle())
        
        let route = Route()
        
        route.bounds = polygon?.getBounds()
        route.length = result.getBest().getDistance()
        
        complete(route)
    }
    
    func getMessage(result: GHResponse) -> String {
        
        let path : PathWrapper = result.getBest()
        let distancePath = path.getDistance()
        let distance = round( distancePath / 1000 * 100) / 100
        let message = "Your route is " + String(distance) + "km"
        return message
    }
    
    func getResult(startPos: NTMapPos, stopPos: NTMapPos) -> GHResponse? {
        var result: GHResponse?
        let request : GHRequest?
        
        let longitudStart84 = projection.toWgs84(startPos).getX()
        let latitudStart84 = projection.toWgs84(startPos).getY()
        
        let longitudStop84 = projection.toWgs84(stopPos).getX()
        let latitudStop84 = projection.toWgs84(stopPos).getY()

    
        request = GHRequest(double: latitudStart84, with: longitudStart84, with: latitudStop84, with: longitudStop84).setVehicleWith("car").setWeightingWith("fastest").setLocaleWith("es")
        
        result = self.hopper?.route(with: request)
        
        var routeInfo : String = ""

        if (result?.hasErrors())! {
            print("\(result!.getErrors())")
            routeInfo = routeInfo + ("\(result?.getErrors())\n")
            return nil
        }
        
        return result
        
    }

    func createRoutePoint(position: NTMapPos, instruction: Instruction, source: NTLocalVectorDataSource) {
        
        let action = instruction.getSign()
        
        var style = instructionUp
        
        if (action == Instruction_TURN_LEFT) {
            style = instructionLeft
        } else if (action == Instruction_TURN_RIGHT) {
            style = instructionRight
        }
        
        let marker = NTMarker(pos: position, style: style)
        source.add(marker)
    }
    
    func createPolyLine(result: GHResponse, color: NTColor) -> NTLine {
        let builder = NTLineStyleBuilder()
        builder?.setColor(color)
        builder?.setWidth(7)
        
        let points = result.getBest().getPoints()!
        let linePoses = NTMapPosVector()
        
        var i : jint = 0
        while i <= points.size() {
            linePoses?.add(projection.fromWgs84(NTMapPos(x: points.getLatitudeWith(i), y: points.getLongitudeWith(i))))
            i += 1
        }
        
        return NTLine(poses: linePoses, style: builder?.buildStyle())
    }
    
    func setStartMarker(position: NTMapPos) {
        routeDataSource?.clear()
        stopMarker?.setVisible(false)
        startMarker?.setPos(position)
        startMarker?.setVisible(true)
    }
    
    func setStopMarker(position: NTMapPos) {
        stopMarker?.setPos(position)
        stopMarker?.setVisible(true)
    }
    
    func initGraphhoper(){
        let location: String? = Bundle.main.path(forResource: "graph-data", ofType: "osm-gh")
        self.hopper = GraphHopper()
        self.hopper!.setCHEnabledWithBoolean(true)
//        self.hopper!.setEnableInstructionsWithBoolean(true)
        self.hopper!.setAllowWritesWithBoolean(true)
        self.hopper!.setEncodingManagerWith(EncodingManager.init(nsString: "car"))
        self.hopper!.forMobile()
        self.hopper!.load__(with: location)
        print(self.hopper!.getStorage().getBounds())
        
    }
}




