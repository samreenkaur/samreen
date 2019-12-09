//
//  LeaveStatusTableViewCell.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

class LeaveStatusTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblLeaveType: UILabel!
    @IBOutlet weak var lblShiftType: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var viewAttachments: UIView!
    @IBOutlet weak var lblAttachments: UILabel!
    @IBOutlet weak var viewAttachmentsHeight: NSLayoutConstraint!
    @IBOutlet weak var viewResponseReason: UIView!
    @IBOutlet weak var lblResponseReason: UILabel!
    @IBOutlet weak var viewResponseReasonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnCancelHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
