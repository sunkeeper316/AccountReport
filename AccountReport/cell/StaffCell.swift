//
//  StaffCell.swift
//  AccountReport
//
//  Created by 黃德桑 on 2019/12/31.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class StaffCell: UITableViewCell {

    @IBOutlet weak var lbStaffJob: UILabel!
    @IBOutlet weak var lbStaffStartDate: UILabel!
    @IBOutlet weak var lbStaffName: UILabel!
    @IBOutlet weak var lbStaffPhone: UILabel!
    @IBOutlet weak var btStaff: UIButton!
    @IBOutlet weak var lbStaffRemark: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
