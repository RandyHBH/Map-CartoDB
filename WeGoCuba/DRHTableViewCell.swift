//
//  DRHTableViewCell.swift
//  WeGoCuba
//
//  Created by Randy Hector Bartumeu Huergo on 10/26/17.
//  Copyright © 2017 Randy Hector Bartumeu Huergo. All rights reserved.
//

import UIKit

class DRHTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configureWithItem(item: LMTableViewDataModelItem) {
        
        avatarImageView?.image = UIImage(named: item.avatarImageURL!)
        titleLabel?.text = item.title
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
