//
//  SearchCategoriesViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/31/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SearchCategoriesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func newInstance() -> SearchCategoriesViewController {
        let searchCategoriesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCategoriesViewController") as! SearchCategoriesViewController
        return searchCategoriesVC
    }
    
}

extension SearchCategoriesViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Categories")
    }

}
