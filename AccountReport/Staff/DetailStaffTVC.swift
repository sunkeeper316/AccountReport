
import UIKit

class DetailStaffTVC: UITableViewController {

    var staff:Staff?
    var staffs = [Staff]()
    var timer : Timer?
    var checkImage = false
    var placeHolderText = "寫一些備註..."
    var image:UIImage?
    var date = Date()
    let calendar = Calendar.current
    var datecomponents : DateComponents?
    var activityIndicatorView: UIActivityIndicatorView!
    var completionHandler:((Staff) -> Void)?
    @IBOutlet weak var lbNoImage: UILabel!
    @IBOutlet weak var ivStaff: UIImageView!
    @IBOutlet weak var lbStaffName: UILabel!
    @IBOutlet weak var lbStaffJob: UILabel!
    @IBOutlet weak var lbStaffPhone: UILabel!
    @IBOutlet weak var lbStaffStartDate: UILabel!
    @IBOutlet weak var lbStaffPay: UILabel!
    @IBOutlet weak var lbStaffPayType: UILabel!
    @IBOutlet weak var tvStaffRemark: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "員工"
        if let staff = staff {
            datecomponents = DateComponents()
            datecomponents?.calendar = Calendar.current
            date = staff.startDate!
            datecomponents = calendar.dateComponents([.day ,.month,.year], from: date)
            lbStaffStartDate.text = "\(datecomponents!.year!).\(datecomponents!.month!).\(datecomponents!.day!)."
            tvStaffRemark.textColor = .black
            lbStaffPayType.text = staff.moneyType
            tvStaffRemark.text = staff.staffRemark
            lbStaffJob.text = staff.staffJob
            lbStaffPhone.text = staff.staffphone
            lbStaffName.text = staff.staffName
            lbStaffPay.text = "\(staff.staffpay ?? 0)"
            if staff.imageUrl != nil , staff.imageUrl != ""{
                lbNoImage.text = ""
                fetchImage(url: URL(string: staff.imageUrl!)) { (image) in
                    DispatchQueue.main.async {
                        self.ivStaff.image = image
                        self.image = image
                        
                    }
                }
            }
        }
    }

    @IBAction func clickCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickSave(_ sender: UIBarButtonItem) {
    }
    @IBAction func clickImage(_ sender: UIButton) {
    }
    func fetchImage(url: URL?, completionHandler: @escaping (UIImage?) -> ()) {
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    completionHandler(image)
                } else {
                    completionHandler(nil)
                }
            }
            task.resume()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
