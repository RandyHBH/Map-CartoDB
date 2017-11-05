//
//  RoutingChoises.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/5/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CircleProgressView

enum ChoiseType {
    case car
    case bike
    case foot
}

extension ChoiseType {
    
    struct Selection {
        var type: String
        var progress: Float
    }
    
    var selection: Selection {
        switch self {
        case .car: return Selection(type: "car", progress: 0)
        case .bike: return Selection(type: "bike", progress: 0)
        case .foot: return Selection(type: "foot", progress: 0)
        }
    }
}
class RoutingChoices: UIView {
    
    @IBOutlet var circlesProgressViews: [CircleProgressView]!
    @IBOutlet var choisesButtons: [UIButton]!
    
    fileprivate var selectedIndex = 0
    
    var selectedChoise: ChoiseType? {
        switch selectedIndex {
        case 0: return .car
        case 1: return .bike
        case 2: return .foot
        default: return nil
        }
    }
    
    override func awakeFromNib() {
        resetCirclePV()
        
        highLightChoise(sender: choisesButtons[selectedIndex], circlePV: circlesProgressViews[selectedIndex])
    }
    
    @IBAction func selectChoise(_ sender: UIButton) {
        
        let tempIndex = choisesButtons.index(of: sender)!
        
        guard selectedIndex != tempIndex else {
            return
        }
        
        selectedIndex = tempIndex
        let selectedcirclePV = circlesProgressViews[selectedIndex]
        
        highLightChoise(sender: sender, circlePV: selectedcirclePV)
    }
}

fileprivate extension RoutingChoices {
    
    func resetCirclePV() {
        for circlePV in circlesProgressViews {
            circlePV.progress = 0
        }
    }
    
    func highLightChoise(sender: UIButton, circlePV: CircleProgressView) -> Void {
        sender.imageView?.tintColor = Colors.appBlue
        circlePV.centerFillColor = .white
        circlePV.progress = 0
    }
}

