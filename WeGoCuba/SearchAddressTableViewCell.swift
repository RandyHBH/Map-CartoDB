//
//  SearchAddressTableViewCell.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/31/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class SearchAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var calleFirstSubLabel: UILabel!
    @IBOutlet weak var calleSecondSubLabel: UILabel!
    @IBOutlet weak var distanciaLabel: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configureWithItem(item: SearchAddressDataModelItem) {
        
        ciudadLabel.text = item.ciudad
        calleFirstSubLabel.text = item.calleFirst
        calleSecondSubLabel.text = item.calleSecond
        distanciaLabel.text = "\(item.distancia!) km"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
