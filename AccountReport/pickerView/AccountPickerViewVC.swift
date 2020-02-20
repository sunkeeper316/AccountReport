import Firebase
import UIKit

class AccountPickerViewVC: UIViewController ,UIPickerViewDelegate ,UIPickerViewDataSource {
    @IBOutlet weak var pickView: UIPickerView!
    @IBOutlet weak var btAdd: UIButton!
    var segmentedIndex:Int?
    var identifier:String!
    var infostring : String?
    var date = [Int]()
    var completionHandler:((String) -> Void)?
    var completionDateHandler:(([Int]) -> Void)?
    var payTypes = ["日薪","月薪"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickView.delegate = self
        self.pickView.dataSource = self
        if identifier == "AccountClass"{
            if segmentedIndex == 0 {
                infostring = incomes.first
            }else if segmentedIndex == 1{
                infostring = outlays.first
            }
        }else if identifier == "datepicker"{
            pickView.selectRow(date[0] - 1, inComponent: 0, animated: true)
            pickView.selectRow(date[1] - 1, inComponent: 1, animated: true)
            pickView.selectRow(date[2] - 1, inComponent: 2, animated: true)
        }else if identifier == "PayType"{
            infostring = payTypes.first
            btAdd.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func clickAdd(_ sender: Any) {
        if identifier == "AccountClass"{
            let alert = UIAlertController(title: "新增分類", message: nil, preferredStyle: .alert)
                    alert.addTextField(configurationHandler: {
                        (inputTextField: UITextField) in
                        inputTextField.placeholder = "請輸入方式名稱"
                        //inputTextField.text = itemText
                    })
                    let okAction = UIAlertAction(title: "確認", style: .default) { (okAction: UIAlertAction) in
                        // 按下 OK 之後要執行的動作
                        // 如果可以取得 textField 的值
                        if let inputText = alert.textFields?[0].text {
                            if self.segmentedIndex == 0 {
                                incomes.append(inputText)
                                self.uploadClass(className: "incomes", newClass: inputText)
                            }else if self.segmentedIndex == 1{
                                outlays.append(inputText)
                                self.uploadClass(className: "outlays", newClass: inputText)
                            }else{
                                caseClasses.append(inputText)
                                self.uploadClass(className: "caseClasses", newClass: inputText)
                            }
                            self.completionHandler!(inputText)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
        }
        
    }
    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickOK(_ sender: Any) {
        if identifier == "AccountClass" {
            completionHandler!(infostring!)
        }else if identifier == "datepicker" {
            completionHandler!(infostring!)
            completionDateHandler!(date)
        }else if identifier == "PayType"{
            completionHandler!(infostring!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if identifier == "AccountClass"{
            return 1
        }else if identifier == "datepicker"{
            return 3
        }else if identifier == "PayType"{
            return 1
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if identifier == "AccountClass"{
            if segmentedIndex == 0 {
                return incomes.count
            }else if segmentedIndex == 1{
                return outlays.count
            }else {
                return caseClasses.count
            }
        }else if identifier == "datepicker"{
            switch component {
            case 0 :
                return 9999
            case 1 :
                return 12
            case 2 :
                return 31
            default:
                return 0
            }
        }else if identifier == "PayType"{
            return payTypes.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if identifier == "AccountClass"{
            if segmentedIndex == 0 {
                return incomes[row]
            }else if segmentedIndex == 1{
                return outlays[row]
            }else {
                return caseClasses[row]
            }
        }else if identifier == "datepicker"{
            switch component {
            case 0 :
                return "\(row + 1) 年"
                
            case 1 :
                return "\(row + 1) 月"
                
            case 2 :
                return "\(row + 1) 日"
            default:
                return ""
            }
        }else if identifier == "PayType"{
            return payTypes[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if identifier == "AccountClass" {
            if segmentedIndex == 0 {
                infostring = incomes[row]
            }else if segmentedIndex == 1{
                infostring = outlays[row]
            }else {
                infostring = caseClasses[row]
            }
        }else if identifier == "datepicker" {
            var text = ""
            let maxday = numberOfDaysInThisMonth(currentYear:pickerView.selectedRow(inComponent: 0) + 1,currentMonth:pickerView.selectedRow(inComponent: 1) + 1)
            //            print(maxday)
                        if pickerView.selectedRow(inComponent: 2) + 1 > maxday{
                            pickerView.selectRow(maxday - 1, inComponent: 2, animated: true)
                        }
            text.append("\(pickerView.selectedRow(inComponent: 0) + 1)年")
            text.append("\(pickerView.selectedRow(inComponent: 1) + 1)月")
            text.append("\(pickerView.selectedRow(inComponent: 2) + 1)日")
            date = [pickerView.selectedRow(inComponent: 0) + 1,pickerView.selectedRow(inComponent: 1) + 1,pickerView.selectedRow(inComponent: 2) + 1]
            infostring = text
        }else if identifier == "PayType"{
            infostring = payTypes[row]
        }
    }
    func numberOfDaysInThisMonth(currentYear:Int,currentMonth:Int) ->Int{
        let dateComponents = DateComponents(year: currentYear , month: currentMonth )
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month,for: date)
        return range?.count ?? 0
    }

    func uploadClass(className:String,newClass:String){
        let db = Firestore.firestore()
        db.collection("UserAccount").document("\(userId)").updateData([className : FieldValue.arrayUnion([newClass])])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
