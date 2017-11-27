//
//  RoutePTPView.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/3/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

class RouteButtonsView: UIView {
    
    @IBOutlet weak var ptpContainer: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ptpButtonViewContainer: UIView!
    @IBOutlet weak var ptpButton: UIButton!
    
    @IBOutlet weak var routeContainer: UIView!
    @IBOutlet weak var routeButton: UIButton!
    
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    @IBOutlet weak var goNavigationContainer: UIView!
    @IBOutlet weak var goNavigationButton: UIButton!
    
    // TODO: Ver a quien pertenece el logo. Por ahora lo dejo aqui!!!
    @IBOutlet weak var logoWaterMark: UIImageView!
    
    var routeInfo: Route?
    @IBOutlet weak var infoBar: InfoBar!
    
    var isActivePTPButton = false
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView?
    
    // TODO: Verify where need to be. Now is in MapViewController and here
    @IBOutlet weak var routingChoices: RoutingChoices!
    @IBOutlet weak var routingPositionSelect: RoutingPositionsSelect!
    
    @IBOutlet weak var stopMarkerView: ShowStopMarker!
    
    var map: NTMapView!
    
    var routeController: RouteController?
    var basicEvents: BasicMapEvents?
    
    weak var ptpDelegate: PTPButtonDelegate?
    weak var routeDelegate: RouteButtonDelegate?
    weak var goDelegate: GoButtonDelegate?
    
    override func awakeFromNib() {
        
        setImageToPTPButton()
    }
    
    @objc private func getSelectStartOptionUpdate() {
        
        if let data = DataContainer.instance.selectedStartOption {
            print(data)
            switch data {
            case .ubicacionActual:
                AppState.instance.mapState = .WAITING_FOR_END_CLICK
            default:
                AppState.instance.mapState = .WAITING_FOR_START_CLICK
            }
        }
    }
    
    @objc private func getSelectEndOptionUpdate() {
        
        if let data = DataContainer.instance.selectedEndOption {
            print(data)
            switch data {
            case .dirección:
                return
            case .favorito:
                return
            case .reciente:
                return
            default:
                AppState.instance.mapState = .WAITING_FOR_END_CLICK
            }
        }
    }
    
    @objc private func getSelectRouteModeUpdate() {
        
        if DataContainer.instance.selectedRouteModeOption != nil {
            
            let startPosition: NTMapPos = map.getOptions().getBaseProjection().fromWgs84(routeInfo!.startPos)
            let stopPosition: NTMapPos = map.getOptions().getBaseProjection().fromWgs84(routeInfo!.endPos)
            
            AppState.instance.routeState = .CALCULATING_ROUTE
            
            showRoute(start: startPosition, stop: stopPosition)
        }
    }
    
    @IBAction func ptpButtonTapped (_ sender: UIButton) {
        
        ptpContainer.isHidden = true
        
        ptpDelegate?.ptpButtonTapped(first: isActivePTPButton, second: isActivePTPButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectStartOptionUpdate), name: .RoutingPositionsSelectStartNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectEndOptionUpdate), name: .RoutingPositionsSelectEndNotification, object: nil)
        
        isActivePTPButton = !isActivePTPButton
        AppState.instance.routeState = .ROUTE_FROM_TWO_POINT
        
        getSelectStartOptionUpdate()
    }
    
    @IBAction func routeButtonTapped (_ sender: UIButton) {
        
        var startPosition: NTMapPos?
        var stopPosition: NTMapPos?
        
        if let startPos = routeInfo?.startPos, let endPos = routeInfo?.endPos {
            startPosition = startPos
            
            stopPosition = endPos
        } else {
            startPosition = NTMapPos()
            stopPosition = NTMapPos()
        }
        
        fillLocationPoints(start: &startPosition!, end: &stopPosition!)
        
        self.hideRouteButton()
        
        // SET THE ROUTE STATE TO CALCULATING TO AVOID THE USER CHANGE THE MARKERS UNTIL CALCULATIONS FINISH
        AppState.instance.routeState = .CALCULATING_ROUTE
        
        showRoute(start: startPosition!, stop: stopPosition!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectRouteModeUpdate), name: .RouteModeSelectNotification, object: nil)
    }
    
    func fillLocationPoints(start: inout NTMapPos, end: inout NTMapPos) {
        
        guard let latestLocation = DataContainer.instance.latestLocation else { return }
        guard let endLocation = basicEvents?.stopPosition else { return }
        
        switch AppState.instance.routeState {
            
        case .ROUTE_FROM_ONE_POINT:
            let latitude = Double(latestLocation.coordinate.latitude)
            let longitude = Double(latestLocation.coordinate.longitude)
            
            let projection = map.getOptions().getBaseProjection()
            
            start = projection!.fromWgs84(NTMapPos(x: longitude, y: latitude))
            end = endLocation
            
        case .ROUTE_FROM_TWO_POINT:
            if let startLocation = basicEvents?.startPosition {
                
                start = startLocation
            } else {
                
                let latitude = Double(latestLocation.coordinate.latitude)
                let longitude = Double(latestLocation.coordinate.longitude)
                
                let projection = map.getOptions().getBaseProjection()
                
                start = projection!.fromWgs84(NTMapPos(x: longitude, y: latitude))
            }
            
            end = endLocation
            
        case .ROUTE_CALCULATED:
            start = map.getOptions().getBaseProjection().fromWgs84(start)
            end = endLocation

        default:
            break
        }
    }
    
    func showRoute(start: NTMapPos, stop: NTMapPos) {
        
        activityIndicator?.startAnimating()
        
        let selectedVehicle = DataContainer.instance.selectedVehicle
        
        routeController?.showRoute(start: start, stop: stop, vehicle: selectedVehicle!.rawValue, complete: { (result, info) in
            
            if result == nil {
                self.handle(error: NSError(domain: info!, code: 1, userInfo: nil))
                return
            }
            
            self.routeController?.sendDrawroute(result: result!, complete: { route in
                
                route.startPos = self.map.getOptions().getBaseProjection().toWgs84(start)
                route.endPos = self.map.getOptions().getBaseProjection().toWgs84(stop)

                self.routeInfo = route
                
                self.infoBar.setUpInfo(routeInfo: self.routeInfo!, map: self.map)
                
                self.activityIndicator?.stopAnimating()
                
                // NEED TO GET THE STATE BEFORE THE ACTUAL ONE SOMETIMES FOR SOME BEHAVEIOR
                switch AppState.instance.previousRouteState! {
                    
                case .ROUTE_FROM_ONE_POINT:
                    self.hideGoNavigationButton(state: false)
                    self.hidePTPContainer(state: true)
                    self.ptpDelegate?.ptpButtonTapped(first: false, second: true)
                    
                default:
                    self.hideGoNavigationButton()
                    self.hideRoutePointsSelectionView(true)
                }
                
                self.switchWaterMarkState(active: true)
                self.hideInfoBar(state: false)
                
                // SET THE ROUTE STATE TO CALCULATED SO NOW THE USER CAN CHANGE THE FINAL MARKER UNTIL ROUTING FINISH
                AppState.instance.routeState = .ROUTE_CALCULATED
            })
        })
    }
    
    // TODO: Is not complete yet, all error handling and info messages are made here
    func handle(error: Error) {
        
        self.basicEvents?.cleaningLeftOvers()
        self.activityIndicator?.stopAnimating()
    }
    
    @IBAction func locationButtonTapped (_ sender: UIButton) {
        
        if let latestLocation = DataContainer.instance.latestLocation {
            
            let latitude = Double(latestLocation.coordinate.latitude)
            let longitude = Double(latestLocation.coordinate.longitude)
            
            let projection = map.getOptions().getBaseProjection()
            let position = projection?.fromWgs84(NTMapPos(x: longitude, y: latitude))
            
            map.setZoom(16, durationSeconds: 2)
            map.setFocus(position, durationSeconds: 1)
        }
    }
    
    @IBAction func GoButtonTapped (_ sender: UIButton) {
        
        let info = NavigationInfo(vehicleIcon: getVehicleIcon(), routeInfo: routeInfo!)
        
        goDelegate?.goButtonTapped(navigationVCInfo: info)
    }
    
    func setUpView(routeController: RouteController, basicEvents: BasicMapEvents, map: NTMapView) -> Void {
        
        self.map = map
        self.routeController = routeController
        self.basicEvents = basicEvents
        self.basicEvents?.delegate = self
        self.routingChoices.delegate = self
        self.infoBar.delegate = self
    }
}

extension RouteButtonsView {
    
    func hideRouteButton(state: Bool = true) {
        DispatchQueue.main.async {
            self.routeContainer.isHidden = state
            self.layoutIfNeeded()
        }
    }
    
    func hideGoNavigationButton(state: Bool = true) {
        DispatchQueue.main.async {
            self.goNavigationContainer.isHidden = state
            self.layoutIfNeeded()
        }
    }
    
    func hidePTPContainer(state: Bool = false) {
        DispatchQueue.main.async {
            self.ptpContainer.isHidden = state
        }
    }
    
    func hideInfoBar(state: Bool = true) {
        DispatchQueue.main.async {
            self.infoBar.isHidden = state
        }
    }
    
    func switchWaterMarkState(active: Bool = false) {
        self.logoWaterMark.image = active ? UIImage(named: "water_mark_active") : UIImage(named: "water_mark")
    }
    
    func hidePTPButton(state: Bool = true){
        DispatchQueue.main.async {
            self.ptpButton.isHidden = state
        }
    }
    
    func hideRoutePointsSelectionView(_ state: Bool) {
        DispatchQueue.main.async {
            self.routingPositionSelect.isHidden = state
        }
    }
    
    func hideStopMarkerView(state: Bool = true) {
        DispatchQueue.main.async {
            self.stopMarkerView.isHidden = state
        }
    }
    
    fileprivate func setImageToPTPButton() {
        ptpButton.setImage(UIImage(named: getVehicleIcon())?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue), for: .normal)
    }
    
    func getVehicleIcon() -> String {
        let vehicle = DataContainer.instance.selectedVehicle.rawValue
        let icon: String?
        switch vehicle {
        case "car": icon = "ic_car_white"
        case "bike": icon = "ic_bike_white"
        case "foot": icon = "ic_on_foot_white"
        case "motorcycle": icon = "ic_motorcycle_white"
        default: icon = nil
        }
        return icon!
    }
}

extension RouteButtonsView: RouteMapEventDelegate {
    
    func startClicked(event: RouteMapEvent) {
        self.routeController?.setStartMarker(event: event)
    }
    
    func stopClicked(event: RouteMapEvent) {
        self.routeController?.setStopMarker(event: event)
        
        switch AppState.instance.routeState {
            
        case .ROUTE_FROM_ONE_POINT:
            hideRouteButton(state: false)
            hidePTPButton()
            
        case .ROUTE_FROM_TWO_POINT:
            hideRouteButton(state: false)
            
        case .CLEAN_ROUTE:
            hideRouteButton(state: false)
            hidePTPButton()
            
        case .ROUTE_CALCULATED:
            hideRouteButton(state: false)
    
        default:
            return
        }
    }
    
    func cleanMarkers() {
        self.routeController?.finishRoute()
        
        switch AppState.instance.routeState {
            
        case .ROUTE_FROM_ONE_POINT:
            hideRouteButton()
            hidePTPButton(state: false)
            
        case .ROUTE_FROM_TWO_POINT:
            endRouting()
            
        case .CLEAN_ROUTE:
            hideRouteButton()
            hidePTPButton(state: false)
            
        default:
            return
        }
    }
    
    func longTap(){
        // NO RESPONDER A LOS LONG-TAPS
    }
    
    func hideLocationButton() {
        let marker = DataContainer.instance.mapModel.locationMarker.userMarker!
        
        let screenWidth: Float = Float(map.frame.width) * 2
        let screenHeight: Float = Float(map.frame.height - 50) * 2
        
        let minScreenPos: NTScreenPos = NTScreenPos(x: 0, y: 0)
        let maxScreenPos: NTScreenPos = NTScreenPos(x: screenWidth, y: screenHeight)
        let screenBounds = NTScreenBounds(min: minScreenPos, max: maxScreenPos)
        
        
        let contain = screenBounds?.contains(map.map(toScreen: marker.getBounds().getCenter()))
        
        if locationContainer.isHidden != contain {
            DispatchQueue.main.async {
                self.locationContainer.isHidden = contain!
            }
        }
    }
    
    func showStopMarkerPosition() {
        let stopMarker = routeController?.getStopMarker()
        print(stopMarker!.getBounds().getCenter().description)
        
        let screenWidth: Float = Float(map.frame.width) * 2
        let screenHeight: Float = Float(map.frame.height - 50) * 2
        
        let minScreenPos: NTScreenPos = NTScreenPos(x: 0, y: 0)
        let maxScreenPos: NTScreenPos = NTScreenPos(x: screenWidth, y: screenHeight)
        let screenBounds = NTScreenBounds(min: minScreenPos, max: maxScreenPos)
        
        let contain = screenBounds!.contains(map.map(toScreen: stopMarker!.getBounds().getCenter()))
        
        let midScreenPos = NTScreenPos(x: Float(map.frame.width), y: Float(map.frame.height - 50))
        
        if contain == false {
            
            let projection = map.getOptions().getBaseProjection()!
            let pos1Wgs = projection.toWgs84(map.screen(toMap: midScreenPos))!
            let pos2Wgs = projection.toWgs84(stopMarker!.getBounds().getCenter())!
            
            self.stopMarkerView.updateDistance(pos1Wgs: pos1Wgs, finalPos: pos2Wgs)
        }
        
        if stopMarkerView.isHidden != contain {
            DispatchQueue.main.async {
                self.stopMarkerView.isHidden = contain
            }
        }
    }
}
}

extension RouteButtonsView: RoutingChoicesDelegate {
    
    func endRouting() {
        
        cleaning()
        
        routeController?.finishRoute()
        basicEvents?.cleaningLeftOvers()
    }
    
    func cleaning() {
        DispatchQueue.main.async {
            
            self.setImageToPTPButton()
            
            self.ptpDelegate?.ptpButtonTapped(first: true, second: true)
            self.ptpContainer.isHidden = false
            
            switch AppState.instance.routeState {
                
            case .ROUTE_FROM_ONE_POINT:
                self.hidePTPButton(state: false)
                
            case.ROUTE_FROM_TWO_POINT:
                self.isActivePTPButton = !self.isActivePTPButton
                
            case .ROUTE_CALCULATED:
                switch AppState.instance.previousRouteState! {
                    
                case .ROUTE_FROM_ONE_POINT:
                    self.hidePTPButton(state: false)
                    
                case.ROUTE_FROM_TWO_POINT:
                    self.isActivePTPButton = !self.isActivePTPButton
                    
                default:
                    return
                }
                
            default:
                return
            }

            self.hideRouteButton()
            self.hideGoNavigationButton()
            self.switchWaterMarkState()
            self.hideInfoBar()
            
             AppState.instance.routeState = .CLEAN_ROUTE
        }
        
        NotificationCenter.default.removeObserver(self, name: .RoutingPositionsSelectStartNotification, object: self)
        
        NotificationCenter.default.removeObserver(self, name: .RoutingPositionsSelectEndNotification, object: self)
        
        NotificationCenter.default.removeObserver(self, name: .RouteModeSelectNotification, object: self)
    }
    
    func dowButtonPressed(state: Bool) {
        hideRoutePointsSelectionView(state)
    }
    
    func routingVehicleChange() {
        
        let startPosition: NTMapPos = map.getOptions().getBaseProjection().fromWgs84(routeInfo!.startPos)
        let stopPosition: NTMapPos = map.getOptions().getBaseProjection().fromWgs84(routeInfo!.endPos)
        
        AppState.instance.routeState = .CALCULATING_ROUTE
        
        showRoute(start: startPosition, stop: stopPosition)
    }
}

extension RouteButtonsView: RouteModeSelectedDelegate {
    func routeModeChanged(mode: String) {
        
    }
}

protocol PTPButtonDelegate: class {
    func ptpButtonTapped(first: Bool, second: Bool)
}

protocol RouteButtonDelegate: class {
    func routeButtonTapped(state: Bool)
}

protocol LocationButtonDelegate: class {
    func locationButtonTapped()
}

protocol GoButtonDelegate: class {
    func goButtonTapped(navigationVCInfo: NavigationInfo)
}

struct NavigationInfo {
    var vehicleIcon: String
    var routeInfo: Route
}
