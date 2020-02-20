

import UIKit

class DatePickerVC: UIViewController {

    @IBOutlet weak var pickerView: UIDatePicker!
    var date : Date?
    var completionHandler:((Date) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let date = date {
           pickerView.setDate(date , animated: true)
           
        }
        
    }
    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickOK(_ sender: Any) {
        completionHandler!(pickerView.date)
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
