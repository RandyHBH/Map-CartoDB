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

class RoutingChoices: UIView {
    
    @IBOutlet var circlesProgressViews: [CircleProgressView]!
    @IBOutlet var choicesButtons: [UIButton]!
    
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
        
        highLightChoise(sender: choicesButtons[selectedIndex], circlePV: circlesProgressViews[selectedIndex])
    }
    
    @IBAction func selectChoise(_ sender: UIButton) {
        
        let tempIndex = choicesButtons.index(of: sender)!
        
        guard selectedIndex != tempIndex else {
            return
        }
        
        // Turn off ChoiseType
        turnOffChoise(sender: choicesButtons[selectedIndex], circlePV: circlesProgressViews[selectedIndex])
        
        // Highlight the new ChoiseType
        let selectedcirclePV = circlesProgressViews[tempIndex]
        
        highLightChoise(sender: sender, circlePV: selectedcirclePV)
        
        selectedIndex = tempIndex
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
    
    func turnOffChoise(sender: UIButton, circlePV: CircleProgressView) -> Void {
        sender.imageView?.tintColor = .white
        circlePV.centerFillColor = Colors.circlePVFillColor
        circlePV.progress = 0
    }
}

