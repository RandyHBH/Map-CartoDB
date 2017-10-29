//
//  MainViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/26/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import SideMenu

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSideMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setupStatusBarColor()
    }

    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        SideMenuManager.menuAnimationBackgroundColor = #colorLiteral(red: 0.07435884327, green: 0.2261409163, blue: 0.5749377012, alpha: 1)
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuWidth = max(round(min((self.view.frame.width), (self.view.frame.height)) * 0.85), 240)
    }
    
    fileprivate func setupStatusBarColor() {
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = #colorLiteral(red: 0.07435884327, green: 0.2261409163, blue: 0.5749377012, alpha: 1)
        statusBarView.backgroundColor = statusBarColor
        self.navigationController?.view.addSubview(statusBarView)
    }

}
