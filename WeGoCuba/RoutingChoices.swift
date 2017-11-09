//
//  RoutingChoises.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/5/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import CircleProgressView

enum ChoiseType: String {
    case car
    case bike
    case foot
}

class RoutingChoices: UIView {
    
    @IBOutlet fileprivate var circlesProgressViews: [CircleProgressView]!
    @IBOutlet fileprivate var choicesButtons: [UIButton]!
    
    fileprivate var selectedIndex = 0
    
    fileprivate var selectedChoise: ChoiseType? {
        switch selectedIndex {
        case 0: return .car
        case 1: return .bike
        case 2: return .foot
        default: return nil
        }
    }
    
    fileprivate var selectedButton: UIButton? {
        switch selectedIndex {
        case 0: return choicesButtons[0]
        case 1: return choicesButtons[1]
        case 2: return choicesButtons[2]
        default: return nil
        }
    }
    
    fileprivate var selectedCirclePV: CircleProgressView? {
        switch selectedIndex {
        case 0: return circlesProgressViews[0]
        case 1: return circlesProgressViews[1]
        case 2: return circlesProgressViews[2]
        default: return nil
        }
    }
    
    override func awakeFromNib() {
        resetCirclePV()
        
        highLightChoise(sender: choicesButtons[selectedIndex], circlePV: circlesProgressViews[selectedIndex])
        DataContainer.sharedInstance.selectedVehicle = selectedChoise
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
        
        DataContainer.sharedInstance.selectedVehicle = selectedChoise
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

extension RoutingChoices {
    
    func startProgress() {
        
        turnOffChoise(sender: selectedButton!, circlePV: selectedCirclePV!)
    }
    
    func finishProgress() {
        
        highLightChoise(sender: selectedButton!, circlePV: selectedCirclePV!)
    }
    
    func updateCirclePV(percent: Double) {
        
        circlesProgressViews[selectedIndex].setProgress(percent, animated: true)
    }
}
