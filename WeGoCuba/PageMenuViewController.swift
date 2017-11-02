//
//  PageMenuViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/31/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PageMenuViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {

        
        settings.style.buttonBarBackgroundColor = Colors.appBlue
        settings.style.buttonBarItemBackgroundColor = Colors.appBlue
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = UIFont(name: "Roboto-Regular", size: 14)!
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = Colors.appWhiteInactive
            newCell?.label.textColor = .white
        }
        
        super.viewDidLoad()
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var arrayView = [UIViewController]()
        
        let addressVC = SearchAddressViewController.newInstance()
        arrayView.append(addressVC)
        let categoriesVC = SearchCategoriesViewController.newInstance()
        arrayView.append(categoriesVC)
        let recentsVC = SearchRecentsViewController.newInstance()
        arrayView.append(recentsVC)

        return arrayView
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
