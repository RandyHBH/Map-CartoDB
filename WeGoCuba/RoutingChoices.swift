//
//  RoutingChoises.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/5/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

enum ChoiseType: String {
    case car
    case motorcycle
    case bike
    case foot
}

class RoutingChoices: UIView {
    
    weak var delegate: RoutingChoicesDelegate?
    
    @IBOutlet fileprivate var containersSelectionsViews: [UIView]!
    @IBOutlet fileprivate var choicesButtons: [UIButton]!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    fileprivate var selectedIndex = 0
    
    fileprivate var selectedChoise: ChoiseType? {
        switch selectedIndex {
        case 0: return .car
        case 1: return .motorcycle
        case 2: return .bike
        case 3: return .foot
        default: return nil
        }
    }
    
    fileprivate var selectedButton: UIButton? {
        switch selectedIndex {
        case 0: return choicesButtons[0]
        case 1: return choicesButtons[1]
        case 2: return choicesButtons[2]
        case 3: return choicesButtons[3]
        default: return nil
        }
    }
    
    fileprivate var selectedCirclePV: UIView? {
        switch selectedIndex {
        case 0: return containersSelectionsViews[0]
        case 1: return containersSelectionsViews[1]
        case 2: return containersSelectionsViews[2]
        case 3: return containersSelectionsViews[3]
        default: return nil
        }
    }
    
    override func awakeFromNib() {
        resetContainersSelectionsViews()
        
        highLightChoise(sender: choicesButtons[selectedIndex], containerView: containersSelectionsViews[selectedIndex])
        DataContainer.instance.selectedVehicle = selectedChoise
    }
    
    @IBAction func selectChoise(_ sender: UIButton) {
        
        let tempIndex = choicesButtons.index(of: sender)!
        
        guard selectedIndex != tempIndex else {
            return
        }
        
        // Turn off ChoiseType
        turnOffChoise(sender: choicesButtons[selectedIndex], containerView: containersSelectionsViews[selectedIndex])
        
        // Highlight the new ChoiseType
        let selectedcirclePV = containersSelectionsViews[tempIndex]
        
        highLightChoise(sender: sender, containerView: selectedcirclePV)
        
        selectedIndex = tempIndex
        
        DataContainer.instance.selectedVehicle = selectedChoise
        
        delegate?.routingVehicleChange()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        delegate?.endRouting()
    }
    
    var isDownButtonActive = true
    
    @IBAction func downButtonTapped(_ sender: UIButton) {
        
        rotateDownButton()
        print("Down Button is: " + isDownButtonActive.description)
        delegate?.dowButtonPressed(state: isDownButtonActive)
    }
    
    func rotateDownButton() {
        if isDownButtonActive {
            UIView.animate(withDuration: 0.5, animations: {
                self.downButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
            isDownButtonActive = !isDownButtonActive
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.downButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 3.14159)
            })
            isDownButtonActive = !isDownButtonActive
        }
    }
    
    func resetDownButton() {
        UIView.animate(withDuration: TimeInterval(1), animations: {
            self.downButton.imageView?.transform = CGAffineTransform.identity.inverted()
            self.downButton.imageView?.image = UIImage(named: "ic_down")
        })
    }
}

fileprivate extension RoutingChoices {
    
    func resetContainersSelectionsViews() {
        for container in containersSelectionsViews {
            container.backgroundColor = UIColor.clear
        }
    }
    
    func highLightChoise(sender: UIButton, containerView: UIView) -> Void {
//        sender.imageView?.tintColor = Colors.appBlue
        containerView.backgroundColor = UIColor.lightGray
    }
    
    func turnOffChoise(sender: UIButton, containerView: UIView) -> Void {
//        sender.imageView?.tintColor = .white
        containerView.backgroundColor = UIColor.clear
    }
}

protocol RoutingChoicesDelegate: class {
    
    func endRouting()
    func routingVehicleChange()
    func dowButtonPressed(state: Bool)
}
