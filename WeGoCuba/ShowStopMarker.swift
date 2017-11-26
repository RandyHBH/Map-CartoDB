//
//  ShowStopMarker.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 11/26/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class ShowStopMarker: UIView {
    
    var delegate: ShowStopMarkerDelegate?

    @IBOutlet weak var distanceToMarker: UILabel!
    
    override func awakeFromNib() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(showStopMarkerTapped(_:)))
        addGestureRecognizer(recognizer)
    }
    
    func updateDistance(distance: String) -> Void {
        distanceToMarker.text = distance
    }
    
    func showStopMarkerTapped(_ sender: UITapGestureRecognizer) {
        delegate?.showStopMarker()
    }
}

protocol ShowStopMarkerDelegate {
    func showStopMarker()
}
