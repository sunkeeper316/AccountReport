
import UIKit

class SetinoutVC: UIViewController {

    var keyword:String!
    var tabelView : UITableView!
    
    @IBOutlet weak var tfInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickOK(_ sender: Any) {
        if let key = keyword ,tfInput.text! != "" {
            if key == "income"{
                incomes.append(tfInput.text!)
            }else {
                outlays.append(tfInput.text!)
            }
        }
        tabelView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickCancel(_ sender: Any) {
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
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
