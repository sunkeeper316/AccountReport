

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var lbAccountClass: UILabel!
    @IBOutlet weak var lbAccountName: UILabel!
    @IBOutlet weak var lbAccountNumber: UILabel!
    @IBOutlet weak var btAccountImage: UIButton!
    @IBOutlet weak var lbAccountRemarker: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
