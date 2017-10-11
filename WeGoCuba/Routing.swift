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
    
    init(mapView: NTMapView, hopper: GraphHopper) {
        
        self.mapView = mapView
        self.hopper = hopper
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
        vectorLayer?.setVisibleZoom(NTMapRange(min: 0, max: 24))
        
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
            
            let cantPointInstruction = instruction.getPoints().size()
            
            var j : jint = 0
            while j < cantPointInstruction {
                
                let xLongitud = instruction.getPoints().getLongitudeWith(j)
                let yLatitud = instruction.getPoints().getLatitudeWith(j)
                
                let position = projection.fromWgs84(NTMapPos(x: xLongitud, y: yLatitud))
                
                if (showTurns) {
//                    createRoutePoint(position: position!, instruction: instruction, source: routeDataSource!)
                }
                
                vector?.add(position)
                j += 1
            }
            
        }
        
        let polygon = NTPolygon(poses: vector, style: NTPolygonStyleBuilder().buildStyle())
        
        let route = Route()
        
        route.bounds = polygon?.getBounds()
        route.length = result.getBest().getDistance()
        
        complete(route)
    }
    
    func getMessage(result: GHResponse) -> String {
        
        let path : PathWrapper = result.getBest()
        let pathDistance = path.getDistance()
        let distanceKM = round( pathDistance / 1000 * 100) / 100
        let message = "Your route is " + String(distanceKM) + "km"
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
        let size = points.size()
        let linePoses = NTMapPosVector()
        
        var i : jint = 0
        while i < size {
            linePoses?.add(projection.fromWgs84(NTMapPos(x: points.getLongitudeWith(i), y: points.getLatitudeWith(i))))
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
    
    
    
    func cleaning() {
        routeDataSource?.clear()
        stopMarker?.setVisible(false)
        startMarker?.setVisible(false)
    }
}





