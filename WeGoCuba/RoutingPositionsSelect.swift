//
//  RoutingPositionsSelect.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/9/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import DropDown

class RoutingPositionsSelect: UIView {
    
    weak var delegate: RoutingPositionsSelectDelegate?
    
    @IBOutlet weak var startPointImage: UIImageView!
    @IBOutlet weak var startPointButton: UIButton!
    
    @IBOutlet weak var endPointImage: UIImageView!
    @IBOutlet weak var endPointButton: UIButton!
    
    let chooseStartPoint = DropDown()
    let chooseEndPoint = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseStartPoint,
            self.chooseEndPoint
        ]
    }()
    
    override func awakeFromNib() {
        
        // TODO: SEARCH FURTHER.I NEED TO SET THE TINT COLOR
        //       HERE, IB BUG??
        self.startPointImage.image = self.startPointImage.image?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue)
        
        self.endPointImage.image = self.endPointImage.image?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue)
        
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .automatic }
        dropDowns.forEach { $0.direction = .bottom }
        dropDowns.forEach { $0.selectRow(at: 0) }
    }
    
    fileprivate func setupDropDowns() {
        setupChooseStartPoint()
        setupChooseEndPoint()
    }
    
    fileprivate func setupChooseStartPoint() {
        chooseStartPoint.anchorView = startPointButton
        
        chooseStartPoint.bottomOffset = CGPoint(x: 0, y:(chooseStartPoint.anchorView?.plainView.bounds.height)!)
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseStartPoint.dataSource =  DataSourceStartDropDown.allValues.map{($0.rawValue)}

        // Action triggered on selection
        chooseStartPoint.selectionAction = { [unowned self] (index, item) in
            self.startPointButton.setTitle(item, for: .normal)
            DataContainer.instance.selectedStartOption = DataSourceStartDropDown(rawValue: item)!
            self.matchSelectionsToRouteSearchType()
            self.delegate?.startPointTypeChange(selected: item)
        }
        
        // Start Slection on Dropdown
        chooseStartPoint.selectRow(at: DataSourceStartDropDown.ubicacionActual.hashValue)
        startPointButton.setTitle(DataSourceStartDropDown.ubicacionActual.rawValue, for: .normal)
        DataContainer.instance.selectedStartOption  = DataSourceStartDropDown.ubicacionActual
        
    }
    
    fileprivate func setupChooseEndPoint() {
        chooseEndPoint.anchorView = endPointButton
        
        chooseEndPoint.bottomOffset = CGPoint(x: 0, y:(chooseEndPoint.anchorView?.plainView.bounds.height)!)

        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseEndPoint.dataSource = DataSourceEndDropDown.allValues.map{( $0.rawValue)}

        
        // Action triggered on selection
        chooseEndPoint.selectionAction = { [unowned self] (index, item) in
            self.endPointButton.setTitle(item, for: .normal)
            DataContainer.instance.selectedEndOption = DataSourceEndDropDown(rawValue: item)!
            self.matchSelectionsToRouteSearchType()
            self.delegate?.endPointTypeChange(selected: item)
        }
        
        // Start Slection on Dropdown
        chooseEndPoint.selectRow(at: DataSourceEndDropDown.marcarEnElMapa.hashValue)
        endPointButton.setTitle(DataSourceEndDropDown.marcarEnElMapa.rawValue, for: .normal)
        DataContainer.instance.selectedEndOption = DataSourceEndDropDown.marcarEnElMapa
    }
    
    fileprivate func matchSelectionsToRouteSearchType() {
        
        let selectedStartOption = DataContainer.instance.selectedStartOption
        let selectedEndOption = DataContainer.instance.selectedEndOption
        
        switch (selectedStartOption!,selectedEndOption!) {
        case (.ubicacionActual,.marcarEnElMapa):
            AppState.instance.routeState = .ROUTE_FROM_ONE_POINT
        case (.ubicacionActual,.dirección):
            AppState.instance.routeState = .ROUTE_FROM_ONE_POINT
        case (.ubicacionActual,.favorito):
            AppState.instance.routeState = .ROUTE_FROM_ONE_POINT
        case (.ubicacionActual,.reciente):
            AppState.instance.routeState = .ROUTE_FROM_ONE_POINT
        default:
            AppState.instance.routeState = .ROUTE_FROM_TWO_POINT
        }
    }
    
    @IBAction func chooseStartPoint(_ sender: AnyObject) {
        chooseStartPoint.show()
        
    }
    
    @IBAction func chooseEndPoint(_ sender: AnyObject) {
        chooseEndPoint.show()
    }
}

protocol RoutingPositionsSelectDelegate: class {
    
    func startPointTypeChange(selected: String)
    func endPointTypeChange(selected: String)
}

enum DataSourceStartDropDown: String, EnumCollection {
    
    case ubicacionActual = "Ubicación Actual"
    case marcarEnElMapa = "Marcar en el Mapa"
    case favorito = "Favorito"
    case dirección = "Dirección"
    case reciente = "Reciente"
}

enum DataSourceEndDropDown: String, EnumCollection {
    
    case marcarEnElMapa = "Marcar en el Mapa"
    case favorito = "Favorito"
    case dirección = "Dirección"
    case reciente = "Reciente"
}

public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
}

public extension EnumCollection {
    
    public static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var allValues: [Self] {
        return Array(self.cases())
    }
}
