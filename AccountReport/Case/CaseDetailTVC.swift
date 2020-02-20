
import UIKit
import Firebase

class CaseDetailTVC: UITableViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextViewDelegate{
    
    var timer : Timer?
    var oneCase : Case?
    var caseDiarys = [CaseDiary]()
    var caseIncomes = [IncomeAccount]()
    var caseOutlays = [OutlayAccount]()
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbCaseName: UILabel!
    @IBOutlet weak var lbCasePosition: UILabel!
    @IBOutlet weak var lbNoimage: UILabel!
    @IBOutlet weak var ivAccount: UIImageView!
    @IBOutlet weak var ivAccount2: UIImageView!
    @IBOutlet weak var ivAccount3: UIImageView!
    @IBOutlet weak var lbDiaryDate: UILabel!
    @IBOutlet weak var lbIncomeNumber: UILabel!
    @IBOutlet weak var lbOutlayNumber: UILabel!
    @IBOutlet weak var lbTotal: UILabel!
    
    @IBOutlet weak var activity1: UIActivityIndicatorView!
    @IBOutlet weak var activity2: UIActivityIndicatorView!
    @IBOutlet weak var activity3: UIActivityIndicatorView!
    @IBOutlet weak var activity4: UIActivityIndicatorView!
    @IBOutlet weak var activity5: UIActivityIndicatorView!
    @IBOutlet weak var activity6: UIActivityIndicatorView!
    @IBOutlet weak var activity7: UIActivityIndicatorView!
    
    
    var placeHolderText = "寫一些備註..."
    var newCase:Case!
    var images = [UIImage]()
    var image1:UIImage?
    var image2:UIImage?
    var image3:UIImage?
    var date = Date()
    let calendar = Calendar.current
    var datecomponents : DateComponents?
    var incomeSUM = 0.0
    var outlaySUM = 0.0
    var totalSUM = 0.0
    
    var checkIncome = false
    var checkOutlay = false
    
    @IBOutlet weak var itemStar: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "案件檢視"
        activity1.hidesWhenStopped = true
        activity2.hidesWhenStopped = true
        activity3.hidesWhenStopped = true
        activity4.hidesWhenStopped = true
        activity5.hidesWhenStopped = true
        activity6.hidesWhenStopped = true
        activity7.hidesWhenStopped = true
        
        if let oneCase = oneCase {
            getAllDiary()
            getAllIncomes()
            getAllOutlays()
            lbCaseName.text = oneCase.caseName
            datecomponents = calendar.dateComponents([.year,.month,.day], from: oneCase.date)
            lbDate.text = "\(datecomponents!.year!).\(datecomponents!.month!).\(datecomponents!.day!)"
            if let casePosition = oneCase.casePosition {
                lbCasePosition.text = casePosition
            }
            if oneCase.isMark {
                itemStar.setBackgroundImage(UIImage(named: "starfull"), for: .normal, barMetrics: .default)
            }else{
                itemStar.setBackgroundImage(UIImage(named: "starclear"), for: .normal, barMetrics: .default)
            }
            if oneCase.imageUrl1 != nil , oneCase.imageUrl1 != ""{
                self.lbNoimage.text = ""
                lbNoimage.isHidden = true
                activity1.startAnimating()
                fetchImage(url: URL(string: oneCase.imageUrl1!)) { (image) in
                    DispatchQueue.main.async {
                        self.ivAccount.image = image
                        self.image1 = image
                        self.activity1.stopAnimating()
                    }
                }
            }
            if oneCase.imageUrl2 != nil , oneCase.imageUrl2 != ""{
                activity2.startAnimating()
                fetchImage(url: URL(string: oneCase.imageUrl2!)) { (image) in
                    DispatchQueue.main.async {
                        self.ivAccount2.image = image
                        self.image2 = image
                        self.lbNoimage.text = ""
                        self.activity2.stopAnimating()
                    }
                }
            }
            if oneCase.imageUrl3 != nil , oneCase.imageUrl3 != ""{
                activity3.startAnimating()
                fetchImage(url: URL(string: oneCase.imageUrl3!)) { (image) in
                    DispatchQueue.main.async {
                        self.ivAccount3.image = image
                        self.image3 = image
                        self.lbNoimage.text = ""
                        self.activity3.stopAnimating()
                    }
                }
            }
            if self.timer == nil {
                /* 設定計時器不間斷地(repeats: true)每隔0.5秒鐘(timeInterval: 0.5)就透過現行物件(target: self)呼叫progressChanged方法(selector: #selector(progressChanged))一次 */
                self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(check), userInfo: nil, repeats: true)
            }
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
    func setToolbar(_ textField:UITextField){
        let toolBarHeight:CGFloat = 150
        //製作鍵盤上方幫手
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: toolBarHeight))
        //左邊空白處
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //想製作的按鈕及用途
        let doneBotton: UIBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButtonAction))
        toolBar.setItems([flexSpace,doneBotton], animated: false)
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    //==================================================================
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /* 利用指定的key從info dictionary取出照片 */
        if let pickedImage = info[.originalImage] as? UIImage {
            if ivAccount.image == nil {
                ivAccount.image = pickedImage
                images.append(pickedImage)
            }else if ivAccount2.image == nil {
                ivAccount2.image = pickedImage
                images.append(pickedImage)
            }else if ivAccount3.image == nil {
                ivAccount3.image = pickedImage
                images.append(pickedImage)
            }else{
                ivAccount.image = pickedImage
                images.remove(at: 0)
                images.insert(pickedImage, at: 0)
            }
            
            //            image = pickedImage
            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        }
        lbNoimage.text = ""
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //=====================================================================
    
    @IBAction func clickBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickMark(_ sender: Any) {
        if let oneCase = oneCase {
            if oneCase.isMark {
                oneCase.isMark = false
                setMark(isMark:false)
                itemStar.setBackgroundImage(UIImage(named: "starclear"), for: .normal, barMetrics: .default)
            }else{
                oneCase.isMark = true
                setMark(isMark:true)
                itemStar.setBackgroundImage(UIImage(named: "starfull"), for: .normal, barMetrics: .default)
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "caseDiary"{
            let vc = segue.destination as! MainDiaryVC
            vc.caseDiarys = caseDiarys
            vc.oneCase = oneCase
            
            vc.completionHandler = {(caseDiarys)in
                self.caseDiarys = caseDiarys
                self.lbDiaryDate.text = "\(self.caseDiarys.count)筆"
            }
        }else if segue.identifier == "income" {
            let vc = segue.destination as! MainAccountVC
            vc.oneCase = oneCase
            vc.keyWord = "income"
            vc.accounts = caseIncomes
            vc.completionHandler = {(incomes,oneCase)in
                let incomes = incomes as! [IncomeAccount]
                self.caseIncomes = incomes
                self.oneCase = oneCase
                self.incomeSUM = 0.0
                for c in cases {
                    if c.id == self.oneCase!.id! {
                        c.caseIncomes = self.oneCase!.caseIncomes
                        for c in self.caseIncomes {
                            self.incomeSUM += c.accountNumber ?? 0
                        }
                        self.lbIncomeNumber.text = "\(self.incomeSUM)"
                        self.setTotalSUM()
                    }
                }
                
            }
        }else if segue.identifier == "outlay" {
            let vc = segue.destination as! MainAccountVC
            vc.oneCase = oneCase
            vc.keyWord = "outlay"
            vc.accounts = caseOutlays
            vc.completionHandler = {(outlays,oneCase)in
                self.caseOutlays = outlays as! [OutlayAccount]
                self.oneCase = oneCase
                self.outlaySUM = 0.0
                for c in cases {
                    if c.id == self.oneCase!.id! {
                        c.caseOutlays = self.oneCase!.caseOutlays
                        for c in self.caseOutlays {
                            
                            self.outlaySUM += c.accountNumber ?? 0
                        }
                        self.lbOutlayNumber.text = "\(self.outlaySUM)"
                        self.setTotalSUM()
                    }
                }
            }
        }else if segue.identifier == "imageShow"{
            let vc = segue.destination as! PageImageVC
            images.removeAll()
            vc.isDetail = true
            if let image = ivAccount.image {
                images.append(image)
            }
            if let image = ivAccount2.image {
                images.append(image)
            }
            if let image = ivAccount3.image {
                images.append(image)
            }
            vc.images = images
            vc.completionHandler = {(currentPage) in
                self.images.remove(at: currentPage)
                //                print("currentPage\(currentPage)")
                if currentPage == 0 {
                    self.ivAccount.image = nil
                    self.ivAccount.image = self.ivAccount2.image
                    self.ivAccount2.image = self.ivAccount3.image
                    self.ivAccount3.image = nil
                }else if currentPage == 1 {
                    self.ivAccount2.image = nil
                    self.ivAccount2.image = self.ivAccount3.image
                    self.ivAccount3.image = nil
                }else if currentPage == 2 {
                    self.ivAccount3.image = nil
                }
            }
        }
    }
    
    //==========================================firebase=====================
    @objc func check() {
        
        /* 如果下載進度還沒到最大值就顯示下載進度；下載完成就顯示"Download Finished" */
        if checkIncome , checkOutlay {
//            self.activityIndicatorView.stopAnimating()
//            completionHandler!(account)
           setTotalSUM()
            timer?.invalidate()
            timer = nil
        } 
    }
    func setTotalSUM() {
        totalSUM = incomeSUM - outlaySUM
        if totalSUM > 0 {
            lbTotal.textColor = .blue
            lbTotal.text = "\(totalSUM)"
        }else if totalSUM < 0 {
            lbTotal.textColor = .red
            lbTotal.text = "\(-totalSUM)"
        }else {
            lbTotal.textColor = .black
            lbTotal.text = "\(totalSUM)"
        }
    }
    func setMark(isMark:Bool){
        let db = Firestore.firestore()
        db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase!.id!)").updateData(["isMark":isMark])
        
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
    func getAllDiary(){
        activity4.startAnimating()
        let db = Firestore.firestore()
        db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase!.id!)").collection("caseDiary").getDocuments { (docSnapshot, error) in
            if let docs = docSnapshot?.documents {
                var diarys = [CaseDiary]()
                for doc in docs {
                    let oneDiary = CaseDiary()
                    oneDiary.id = ((doc.data()["caseDiaryid"] ?? "") as! String)
                    let t = ((doc.data()["date"]!) as! Timestamp)
                    oneDiary.date = Date(timeIntervalSince1970: TimeInterval(integerLiteral: t.seconds))
                    oneDiary.content = ((doc.data()["caseContent"] ?? "") as! String)
                    diarys.append(oneDiary)
                }
                self.caseDiarys = diarys
                self.lbDiaryDate.text = "\(diarys.count)筆"
                self.activity4.stopAnimating()
            }
        }
    }
    func getAllIncomes(){
        activity5.startAnimating()
        let db = Firestore.firestore()
        db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase!.id!)").collection("income").getDocuments { (docSnapshot, error) in
            if let docs = docSnapshot?.documents {
                var incomes = [IncomeAccount]()
                for doc in docs {
                    let oneIncome = IncomeAccount()
                    oneIncome.id = ((doc.data()["id"] ?? "") as! String)
                    oneIncome.year = ((doc.data()["year"] ?? 0) as! Int)
                    oneIncome.month = ((doc.data()["month"] ?? 0) as! Int)
                    oneIncome.day = ((doc.data()["day"] ?? 0) as! Int)
                    oneIncome.accountNumber = ((doc.data()["Number"] ?? 0) as! Double)
                    oneIncome.accountName = ((doc.data()["Name"] ?? "") as! String)
                    oneIncome.accountClass = ((doc.data()["class"] ?? "") as! String)
                    oneIncome.accountRemark = ((doc.data()["remark"] ?? "") as! String)
                    oneIncome.imageUrl = ((doc.data()["photoUrl"] ?? "") as! String)
                    incomes.append(oneIncome)
                }
                self.caseIncomes = incomes
                for c in self.caseIncomes {
                    self.incomeSUM += c.accountNumber!
                }
                self.lbIncomeNumber.text = "\(self.incomeSUM)"
                self.checkIncome = true
                self.activity5.stopAnimating()
            }
        }
    }
    func getAllOutlays(){
        activity6.startAnimating()
        let db = Firestore.firestore()
        db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase!.id!)").collection("outlay").getDocuments { (docSnapshot, error) in
            if let docs = docSnapshot?.documents {
                var outlays = [OutlayAccount]()
                for doc in docs {
                    let oneOutlay = OutlayAccount()
                    oneOutlay.id = ((doc.data()["id"] ?? "") as! String)
                    oneOutlay.year = ((doc.data()["year"] ?? 0) as! Int)
                    oneOutlay.month = ((doc.data()["month"] ?? 0) as! Int)
                    oneOutlay.day = ((doc.data()["day"] ?? 0) as! Int)
                    oneOutlay.accountNumber = ((doc.data()["Number"] ?? 0) as! Double)
                    oneOutlay.accountName = ((doc.data()["Name"] ?? "") as! String)
                    oneOutlay.accountClass = ((doc.data()["class"] ?? "") as! String)
                    oneOutlay.accountRemark = ((doc.data()["remark"] ?? "") as! String)
                    oneOutlay.imageUrl = ((doc.data()["photoUrl"] ?? "") as! String)
                    outlays.append(oneOutlay)
                }
                self.caseOutlays = outlays
                for c in self.caseOutlays {
                    self.outlaySUM += c.accountNumber!
                }
                self.lbOutlayNumber.text = "\(self.outlaySUM)"
                self.checkOutlay = true
                self.activity6.stopAnimating()
                //                self.lbDiaryDate.text = "\(diarys.count)筆"
                
            }
        }
    }
    
}
