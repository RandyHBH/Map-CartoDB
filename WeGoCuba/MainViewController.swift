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
        
        setupStatusBarColor()
        setupNavigationControllerBarColor()
    }
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.menuAnimationBackgroundColor = Colors.appBlue
        
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuWidth = max(round(min((self.view.frame.width), (self.view.frame.height)) * 0.85), 240)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        let statusBarView = self.navigationController?.view.viewWithTag(100)
        statusBarView?.removeFromSuperview()
    }
}

extension MainViewController {
    fileprivate func setupStatusBarColor() {
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = Colors.appBlue
        statusBarView.tag = 100
        self.navigationController?.view.addSubview(statusBarView)
    }
    
    fileprivate func setupNavigationControllerBarColor() {
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.tintColor = #colorLiteral(red: 0.9150560498, green: 0.9150775075, blue: 0.9150659442, alpha: 0.7017510776)
    }
}
