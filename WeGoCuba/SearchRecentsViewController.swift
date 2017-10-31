//
//  SearchRecentsViewController.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/31/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SearchRecentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func newInstance() -> SearchRecentsViewController {
        let searchRecentsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchRecentsViewController") as! SearchRecentsViewController
        return searchRecentsVC
    }
}

extension SearchRecentsViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Recents")
    }

}
