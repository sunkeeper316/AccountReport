//
//  MainCaseCell.swift
//  AccountReport
//
//  Created by 黃德桑 on 2019/12/1.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class MainCaseCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var ivStar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
