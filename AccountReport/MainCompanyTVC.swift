import Firebase
import UIKit

class MainCompanyTVC: UITableViewController {

    var showCases = [Case]()
    var targetDate : Date?
    let calendar = Calendar.current
    var datecomponents : DateComponents?
    var otherIncomes = [IncomeAccount]()
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var lbdate: UILabel!
    @IBOutlet weak var lbAllCaseSum: UILabel!
    @IBOutlet weak var lbStaffSum: UILabel!
    @IBOutlet weak var lbOtherIncomeSum: UILabel!
    @IBOutlet weak var lbOtherOutlaySum: UILabel!
    @IBOutlet weak var lbCompanySum: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getCases()
        }
    @IBAction func clickSegmented(_ sender: UISegmentedControl) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    //===================================firebase============================================
    func getCases(){
        targetDate = Date()
        var startDate = Date()
        datecomponents = DateComponents()
        datecomponents!.month = -9
        startDate = calendar.date(byAdding: datecomponents!, to: startDate)!
        let db = Firestore.firestore()
        
        let path = db.collection("UserAccount").document("\(userId)").collection("Staff").whereField("StartDate", isLessThan: targetDate!)
        
        path.whereField("StartDate", isGreaterThan: startDate).getDocuments { (docs, error) in
            if let docs = docs?.documents {
                for doc in docs {
                    let name = (doc.data()["Name"] as! String)
                    print(name)
                }
            }
        }
    }

}
