//
//  NavigationNavBar.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/18/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class NavigationNavBar: UIView {
    
    weak var delegate: NavigationNavBarDelegate?
    
    @IBOutlet weak var endNavigationButton: UIButton!
    @IBOutlet weak var showRouteButton: UIButton!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceMesureLabel: UILabel!
    
    @IBOutlet weak var velocityLabel: UILabel!
    
    @IBOutlet weak var leftDistanceLabel: UILabel!
    @IBOutlet weak var leftDistanceMesureLabel: UILabel!
    
    @IBOutlet weak var arribeTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func endNavigationTapped(_ sender: UIButton) {
        
        delegate?.endNavigationButtonTapped()
    }
    
    @IBAction func showRouteTapped(_ sender: UIButton) {
        
        delegate?.showRouteButtonTapped()
    }
    
    func updateInfo(info: Route) {
        
        distanceLabel.text = info.ditanceToString
        distanceMesureLabel.text = info.distanceType.rawValue
        
        // TODO: Preguntar a Anel
        velocityLabel.text = info.velocityToString
        
        leftDistanceLabel.text = info.distanceToTravel
        leftDistanceMesureLabel.text = info.distanceType.rawValue
            
        arribeTimeLabel.text = info.arribeTime
        leftTimeLabel.text = info.durationTimeToString
    }
    
    func updateProgressBar(progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
    
    func upadateNavBar(info: Route) {
        
    }
}

protocol NavigationNavBarDelegate: class {
    func endNavigationButtonTapped()
    func showRouteButtonTapped()
}
