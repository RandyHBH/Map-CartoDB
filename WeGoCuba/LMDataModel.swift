//
//  DRHDataModel.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/27/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import Foundation

class LMTableViewDataModelItem {
    
    var avatarImageURL: String?
    var title: String?
    
    init?(avatar: String?, title: String?) {
        
        if let avatar = avatar, let title = title {
            
            self.avatarImageURL = avatar
            self.title = title
        } else {
            return nil
        }
    }
}

class LMTableViewDataModel {
    
    weak var delegate: LMTableViewDataModelDelegate?
    
    func requestData() {
        
        var data = [LMTableViewDataModelItem]()
        
        let images = ["ic_explore_white","ic_list_white","ic_language_white","ic_settings_white","ic_info_white","ic_help_white"]
        let titles = ["Navegación","Unidades de medida","Idioma","Ajustes","Información","Ayuda"]
        
        
        for i in 0..<images.count {
            
            if let drhTableViewDataModelItem =
                LMTableViewDataModelItem(avatar:images[i], title: titles[i]) {
                
                data.append(drhTableViewDataModelItem)
            }
        }
        
        delegate?.didRecieveDataUpdate(data: data)
    }
}

protocol LMTableViewDataModelDelegate: class {
    
    func didRecieveDataUpdate(data: [LMTableViewDataModelItem])
    
}
