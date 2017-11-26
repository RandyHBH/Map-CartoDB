//
//  NavigationBanner.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/18/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class NavigationBanner: UIView {
    
    @IBOutlet weak var vehicleImage: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var instructionImage: UIImageView!
    
    @IBOutlet weak var fromStreetLabel: UILabel!
    @IBOutlet weak var toStreetLabel: UILabel!
    
    @IBOutlet weak var speakInstruction: UIButton!
    
    func setSelectedVehicleIcon(icon: String) {
        vehicleImage.imageView?.image = UIImage(named: icon)
    }
    
    func setDistanceToNextInstruction(distance: String) {
        distanceLabel.text = distance
    }
    
    func updateInstruction(current: Instruction, next: Instruction?) {
        
        let action = current.getSign()
        let distance = Double(round(current.getDistance() * 100) / 100)
        
        let distanceString = String(describing: distance) + " m"
        
        var message = ""
        var image: UIImage? = nil
        
        // There are actually even more RoutingActions, but I've covered the most prominent ones
        switch (action) {
        case Instruction_USE_ROUNDABOUT:
            (current as! RoundaboutInstruction).getExitNumber()
            message = "Enter Roundabout in " + distanceString
            print(message)
        case Instruction_LEAVE_ROUNDABOUT:
            message = "Leave roundabout in " + distanceString
            print(message)
        case Instruction_FINISH:
            message = "You'll arrive at your destination in " + distanceString
            print(message)
        case Instruction_CONTINUE_ON_STREET:
            image = UIImage(named: "ic_go_ahead")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue)
        case Instruction_TURN_LEFT:
            image = UIImage(named: "ic_turn_left")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue)
        case Instruction_TURN_RIGHT:
            image = UIImage(named: "ic_turn_right")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue)
        case Instruction_TURN_SHARP_LEFT:
            image = UIImage(named: "ic_turn_left_sharp")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue)
        case Instruction_TURN_SLIGHT_LEFT:
            image = UIImage(named: "ic_turn_left_slightly")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue)
        case Instruction_TURN_SLIGHT_RIGHT:
            image = UIImage(named: "ic_turn_right_slightly")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue)
        case Instruction_TURN_SHARP_RIGHT:
            image = UIImage(named: "ic_turn_right_sharp")?.withRenderingMode(.alwaysTemplate).tint(with: Colors.appBlue)
//        case NTRoutingAction.ROUTING_ACTION_START_AT_END_OF_STREET:
//            
//            if (next != nil) {
//                let nextAction = next!.getAction()
//                
//                switch (nextAction) {
//                case NTRoutingAction.ROUTING_ACTION_TURN_LEFT:
//                    message = "in " + distanceString
//                    image = UIImage(named: "banner_icon_turn_left.png")
//                case NTRoutingAction.ROUTING_ACTION_TURN_RIGHT:
//                    message = "in " + distanceString
//                    image = UIImage(named: "banner_icon_turn_right.png")
//                case NTRoutingAction.ROUTING_ACTION_FINISH:
//                    message = "You'll arrive at your destination in " + distanceString
//                    image = UIImage(named: "icon_banner_finish.png")
//                default:
//                    break
//                }
//            }
            
        default:
            break
        }
        
        DispatchQueue.main.async {
//            self.instructionLabel.text = message.uppercased()
            self.instructionImage.image = image
            self.distanceLabel.text = distanceString
        }
    }
}
