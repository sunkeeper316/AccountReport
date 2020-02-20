
import UIKit

class CaseCell: UITableViewCell {

    @IBOutlet weak var lbAccountClass: UILabel!
    @IBOutlet weak var lbAccountName: UILabel!
    @IBOutlet weak var lbAccountNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
