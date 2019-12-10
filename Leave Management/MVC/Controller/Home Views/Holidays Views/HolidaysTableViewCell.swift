//
//  HolidaysTableViewCell.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

class HolidaysTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
