import Firebase
import UIKit

class UpdateDiaryTVC: UITableViewController ,UITextViewDelegate{

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var tvContent: UITextView!
    var date = Date()
    var oneCase : Case?
    var oneDiary : CaseDiary!
    let calendar = Calendar.current
    var datecomponents : DateComponents?
    var completionHandler:((CaseDiary) -> Void)?
    var placeHolderText = "寫一些日誌..."
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(tvContent)
        tvContent.delegate = self
        if let oneDiary = oneDiary {
            datecomponents = calendar.dateComponents([.year,.month,.day], from: oneDiary.date)
            date = oneDiary.date
            lbDate.text = "\(datecomponents!.year!).\(datecomponents!.month!).\(datecomponents!.day!)"
            tvContent.textColor = .black
            tvContent.text = oneDiary.content
        }
        if tvContent.text == "" {
            tvContent.textColor = .gray
            tvContent.text = placeHolderText
        }
        
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
            oneDiary.content = tvContent.text
            oneDiary.date = date
            completionHandler!(oneDiary)
            updateDiary()
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
    
    func updateDiary(){
        let db = Firestore.firestore()
        let doc = db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase!.id!)")
        doc.collection("caseDiary").document("\(oneDiary!.id!)").updateData([ "date":date,"caseContent" : tvContent.text! ])
        navigationController?.popViewController(animated: true)
        
    }

}
