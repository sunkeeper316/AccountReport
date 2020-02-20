
import Firebase
import UIKit

class InsertDiaryTVC: UITableViewController  ,UITextViewDelegate {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    var oneCase : Case?
    var oneDiary : CaseDiary!
    var date = Date()
    let calendar = Calendar.current
    var datecomponents : DateComponents?
    var completionHandler:((CaseDiary) -> Void)?
    var placeHolderText = "寫一些日誌..."
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(tvContent)
        tvContent.delegate = self
        tvContent.text = placeHolderText
        datecomponents = calendar.dateComponents([.day ,.month,.year], from: date)
        lbDate.text = "\(datecomponents!.year!).\(datecomponents!.month!).\(datecomponents!.day!)"
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row  == 0{
            return 50
        }else {
            return view.safeAreaLayoutGuide.layoutFrame.size.height - 50
        }
       }

    func setToolbar(_ textView:UITextView){
        let toolBarHeight:CGFloat = 150
        //製作鍵盤上方幫手
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: toolBarHeight))
        //左邊空白處
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //想製作的按鈕及用途
        let doneBotton: UIBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButtonAction))
        toolBar.setItems([flexSpace,doneBotton], animated: false)
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
    }

    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tvContent.textColor = .black
        
        if(self.tvContent.text == placeHolderText) {
            self.tvContent.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            self.tvContent.text = placeHolderText
            self.tvContent.textColor = .lightGray
        }
        
    }
    @IBAction func clickSave(_ sender: UIBarButtonItem) {
        if tvContent.text! != "" , tvContent.text! != placeHolderText {
            oneDiary = CaseDiary()
            oneDiary.id = "\(oneCase!.caseDiaryCount!+1)"
            oneDiary.content = tvContent.text
            oneDiary.date = date
            completionHandler!(oneDiary)
            insertDiary()
        }else{
            let alert = UIAlertController(title: "警告", message: "沒有輸入任何東西喔！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion:nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "datepicker"{
            let vc = segue.destination as! DatePickerVC
            vc.date = date
            vc.completionHandler = {(date) in
                self.date = date
                self.datecomponents = self.calendar.dateComponents([.day ,.month,.year], from: date)
                self.lbDate.text = "\(self.datecomponents!.year!).\(self.datecomponents!.month!).\(self.datecomponents!.day!)"
            }
        }
    }
    
    //=========================================================================
    
    func insertDiary(){
        let db = Firestore.firestore()
        let doc = db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase!.id!)")
        doc.updateData(["caseDiaryCount":oneCase!.caseDiaryCount!+1])
        doc.collection("caseDiary").document("\(oneCase!.caseDiaryCount!+1)").setData(["caseDiaryid":"\(oneCase!.caseDiaryCount!+1)" , "date":date,"caseContent" : tvContent.text! ])
        navigationController?.popViewController(animated: true)
        
    }
}
