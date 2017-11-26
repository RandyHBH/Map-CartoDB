//
//  InfoBar.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/13/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import DropDown

class InfoBar: UIView {

    @IBOutlet weak var distancia: UILabel!
    @IBOutlet weak var routeTime: UILabel!
    @IBOutlet weak var arribeTime: UILabel!
    @IBOutlet weak var routeTypeLabel: UILabel!
    @IBOutlet weak var routeTypeDropDown: UIStackView!
    
    var routeInfo: Route?
    var map: NTMapView!
    
    weak var delegate: RouteModeSelectedDelegate?
    
    let chooseRouteMode = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseRouteMode
        ]
    }()
    
    func setUpInfo(routeInfo: Route, map: NTMapView) {
        self.routeInfo = routeInfo
        self.map = map
        self.distancia.text = routeInfo.ditanceToString + " " + routeInfo.distanceType.rawValue
        self.routeTime.text = routeInfo.durationTimeToString
        self.arribeTime.text = routeInfo.arribeTime
    }
    
    override func awakeFromNib() {
        
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .top }
        dropDowns.forEach { $0.selectRow(at: 0) }
    }
    
    fileprivate func setupDropDowns() {
        setupChooseRouteType()
    }
    
    fileprivate func setupChooseRouteType() {
        chooseRouteMode.anchorView = routeTypeDropDown
        
        chooseRouteMode.topOffset = CGPoint(x: 0, y:-(chooseRouteMode.anchorView?.plainView.bounds.height)!)
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseRouteMode.dataSource =  DataSourceRouteModeDropDown.allValues.map{($0.rawValue)}
        
        // Action triggered on selection
        chooseRouteMode.selectionAction = { [unowned self] (index, item) in
            self.routeTypeLabel.text = item
            DataContainer.instance.selectedRouteModeOption = DataSourceRouteModeDropDown(rawValue: item)
            self.delegate?.routeModeChanged(mode: item)
        }
        
        // Start Slection on Dropdown
        chooseRouteMode.selectRow(at: DataSourceRouteModeDropDown.rapida.hashValue)
        self.routeTypeLabel.text = DataSourceRouteModeDropDown.rapida.rawValue
        DataContainer.instance.selectedRouteModeOption = DataSourceRouteModeDropDown.rapida
    }
    
    let mapMoveDuration: Float = 3
    
    @IBAction func routeModeTapped(_ sender: AnyObject) {
        chooseRouteMode.show()
        
        let bounds = routeInfo?.bounds

        map.move(toFit: bounds, screenBounds: self.findScreenBounds(), integerZoom: true, resetRotation: false, resetTilt: false, durationSeconds: mapMoveDuration)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(mapMoveDuration - 0.5), target: self, selector: #selector(onRotationCompleted), userInfo: nil, repeats: false)
        
         map.setFocus(bounds?.getCenter(), durationSeconds: mapMoveDuration)
    }
    
    func onRotationCompleted() {
        let bearing = -Float(routeInfo!.bearing)
        map.setRotation(bearing, targetPos: routeInfo?.bounds?.getCenter(), durationSeconds: mapMoveDuration - 0.5)
    }
    
    func findScreenBounds() -> NTScreenBounds {
        let screenWidth: Float = Float((map.frame.size.width))
        let screenHeight: Float = Float((map.frame.size.height))
        let minScreenPos: NTScreenPos = NTScreenPos(x: 0.0, y: 0.0)
        let maxScreenPos: NTScreenPos = NTScreenPos(x: screenWidth, y:screenHeight)
        return NTScreenBounds(min: minScreenPos, max: maxScreenPos)
    }
}

enum DataSourceRouteModeDropDown: String, EnumCollection {
    
    case rapida = "Rápida"
    case corta = "Corta"
}

protocol RouteModeSelectedDelegate: class {
    func routeModeChanged(mode: String)
}
