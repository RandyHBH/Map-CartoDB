//
//  SearchAddressDataModel.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/31/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

class SearchAddressDataModelItem {
    
    var ciudad: String?
    var calleFirst: String?
    var calleSecond: String?
    var distancia: Float?
    
    init?(ciudad: String?, calleFirst: String?, calleSecond: String?, distancia: Float?) {
        
        if let ciudad = ciudad, let calleFirst = calleFirst, let calleSecond = calleSecond, let distancia = distancia {
            
            self.ciudad = ciudad
            self.calleFirst = calleFirst
            self.calleSecond = calleSecond
            self.distancia = distancia
        } else {
            return nil
        }
    }
}

class SearchAddressDataModel {
    
    weak var delegate: SearchAddressDataModelDelegate?
    
    func requestData() {
        
        var data = [SearchAddressDataModelItem]()
        let first: SearchAddressDataModelItem = SearchAddressDataModelItem(ciudad: "La Habana", calleFirst: "Carretera San Antntonio", calleSecond: "Otra Calle", distancia: 33)!
        data.append(first)
        data.append(first)
        data.append(first)
        delegate?.didRecieveDataUpdate(data: data)
    }
}

protocol SearchAddressDataModelDelegate: class {
    
    func didRecieveDataUpdate(data: [SearchAddressDataModelItem])
    
}
