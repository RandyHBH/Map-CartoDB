//
//  DataContainer.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/6/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation
import CoreLocation


class AppState {
    
    static let instance = AppState()
    
    private init() { }
    
    var routeState: RouteState = .CLEAN_ROUTE {
        didSet {
            if oldValue != .ROUTE_CALCULATED && oldValue != .CALCULATING_ROUTE && oldValue != .CLEAN_ROUTE {
                previousRouteState = oldValue
            }
        }
    }
    var previousRouteState: RouteState?
    var mapState: MapState = .WAITING_FOR_END_CLICK
    
    enum RouteState {
        case CLEAN_ROUTE, ROUTE_FROM_ONE_POINT, ROUTE_FROM_TWO_POINT, ROUTE_CALCULATED, CALCULATING_ROUTE
    }
    
    enum MapState {
        case WAITING_FOR_CLICK, WAITING_FOR_START_CLICK, WAITING_FOR_END_CLICK
    }
}


class DataContainer {
    
    static let instance = DataContainer()
    
    private init() { }
    
    var mapModel: MapModel = MapModel()
    
    var latestLocation: CLLocation?

    var selectedVehicle: ChoiseType! = .car
    
    
    var selectedRouteModeOption: DataSourceRouteModeDropDown? {
        didSet {
            NotificationCenter.default.post(name: .RouteModeSelectNotification, object: nil)
        }
    }
    
    var selectedStartOption: DataSourceStartDropDown? {
        didSet {
            NotificationCenter.default.post(name: .RoutingPositionsSelectStartNotification, object: nil)
        }
    }
    
    var selectedEndOption: DataSourceEndDropDown? {
        didSet {
            NotificationCenter.default.post(name: .RoutingPositionsSelectEndNotification, object: nil)
        }
    }
}
