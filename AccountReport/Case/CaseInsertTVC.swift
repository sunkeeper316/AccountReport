import Firebase
import FirebaseStorage
import UIKit

class CaseInsertTVC: UITableViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextViewDelegate{
    var timer: Timer?
    var checkImage1 = false
    var checkImage2 = false
    var checkImage3 = false
    
    @IBOutlet weak var ivAccount: UIImageView!
    @IBOutlet weak var ivAccount2: UIImageView!
    @IBOutlet weak var ivAccount3: UIImageView!
    @IBOutlet weak var tfCaseName: UITextField!
    @IBOutlet weak var tfCasecontext: UITextField!
    @IBOutlet weak var tvCaseDiary: UITextView!
    @IBOutlet weak var lbNoimage: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    
    var activityIndicatorView: UIActivityIndicatorView!
    var placeHolderText = "寫一些日誌..."
    var newCase:Case!
    var images = [UIImage]()
    var image:UIImage?
    var date = Date()
    let calendar = Calendar.current
    var datecomponents : DateComponents?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新增案件"
        tfCasecontext.tag = 1
        tfCasecontext.delegate = self
        tvCaseDiary.text = placeHolderText
        tfCaseName.delegate = self
        tvCaseDiary.delegate = self
        setToolbar(tvCaseDiary)
        setToolbar(tfCaseName)
        setToolbar(tfCasecontext)
        datecomponents = calendar.dateComponents([.day ,.month,.year], from: date)
        lbDate.text = "\(datecomponents!.year!).\(datecomponents!.month!).\(datecomponents!.day!)"
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if textField.tag == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GPSTextfield") as! GPSTextfieldVC
            vc.stringInfo = textField.text!
            vc.completionHandler = {(inputtext) in
                textField.text = inputtext
            }
            self.present(vc, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TextfieldVC") as! TextfieldVC
            vc.infostring = tfCaseName.text!
            vc.keyword = "CaseName"
            vc.completionHandler = {(inputtext) in
                self.tfCaseName.text = inputtext
            }
            self.present(vc, animated: true, completion: nil)
        }
        return false
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tvCaseDiary.textColor = .black
        
        if(self.tvCaseDiary.text == placeHolderText) {
            self.tvCaseDiary.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            self.tvCaseDiary.text = placeHolderText
            self.tvCaseDiary.textColor = .lightGray
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return view.safeAreaLayoutGuide.layoutFrame.size.height - 280
        }else if indexPath.row == 3{
            return 80
        }else {
            return 50
        }
    }
    
    @IBAction func clickBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //========================================================================================
    
    
    @IBAction func clickImage(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let pickpic = UIAlertAction(title: "相簿", style: .default) { (alertAction) in
            let imagePicker = UIImagePickerController()
            /* 將UIImagePickerControllerDelegate、UINavigationControllerDelegate物件指派給UIImagePickerController */
            imagePicker.delegate = self
            /* 照片來源為相簿 */
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let takepic = UIAlertAction(title: "拍照", style:.default) { (alertAction) in
            let imagePicker = UIImagePickerController()
            /* 將UIImagePickerControllerDelegate、UINavigationControllerDelegate物件指派給UIImagePickerController */
            imagePicker.delegate = self
            /* 照片來源為相機 */
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "取消", style:.default , handler: nil)
        
        
        alertController.addAction(pickpic)
        alertController.addAction(takepic)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
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
            
            image = pickedImage
            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        }
        lbNoimage.text = ""
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //========================================================================================
    
    @IBAction func clickSave(_ sender: Any) {
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        
        newCase = Case()
        
        if tvCaseDiary.text! != "" && tvCaseDiary.text! != placeHolderText{
            //                newCase.caseDiary = tvCaseDiary.text!
            let caseDiary = CaseDiary()
            caseDiary.content = tvCaseDiary.text!
            caseDiary.date = date
            newCase.caseDiarys.append(caseDiary)
        }
        newCase.caseName = tfCaseName.text!
        newCase.casePosition = tfCasecontext.text!
        newCase.date = date
        getCaseCount()
    }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageShow"{
            let vc = segue.destination as! PageImageVC
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
        }else if segue.identifier == "datepicker"{
            let vc = segue.destination as! DatePickerVC
            vc.date = date
            vc.completionHandler = {(date) in
                self.date = date
                self.datecomponents = self.calendar.dateComponents([.day ,.month,.year], from: date)
                self.lbDate.text = "\(self.datecomponents!.year!).\(self.datecomponents!.month!).\(self.datecomponents!.day!)"
            }
            
        }
//        else if segue.identifier == "caseClass"{
//            let vc = segue.destination as! AccountPickerViewVC
//            //            vc.segmentedIndex = segmented.selectedSegmentIndex
//            vc.identifier = "AccountClass"
//            vc.infostring = lbCaseClass.text!
//            vc.completionHandler = {(caseClass) in
//                self.lbCaseClass.text = caseClass
//            }
//        }
        
    }
    
    //=============================================firebase=====================================================================
    
    func uploadPhoto(index:String,image:UIImage,completion: @escaping (URL?) -> () ) {
        
        //        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        let fileReference = Storage.storage().reference().child("user\(userId)_case\(caseCount)_\(index)" + ".jpg")
        let size = CGSize(width: 640, height:image.size.height * 640 / image.size.width)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let data = resizeImage?.jpegData(compressionQuality: 0.3) {
            fileReference.putData(data, metadata: nil) { (_, error) in
                guard error == nil else {
                    print("upload error")
                    return
                }
                fileReference.downloadURL { (url, error) in
                    completion(url)
                }
            }
        }
    }
    
    func setSignup(){
        let db = Firestore.firestore()
        db.collection("User").document("1").collection("\(tfCaseName.text!)").document("\(tfCaseName.text!)").setData(["account":"\(self.tfCaseName.text!)"])
        //        setother()
        
    }
    
    func createCase(){
        let db = Firestore.firestore()
        
        newCase.id = "\(caseCount)"
        newCase.caseDiaryCount = 1
        newCase.caseIncomes = 0
        newCase.caseOutlays = 0
        newCase.caseStaffs = 0
        cases.append(newCase)
        db.collection("UserAccount").document("\(userId)").updateData(["caseCount" : caseCount])
        
        let doc = db.collection("UserAccount").document("\(userId)").collection("Case").document("\(caseCount)")
        doc.setData(["caseid":"\(caseCount)" ,"date":newCase.date, "caseName" : "\(tfCaseName.text!)" , "casePosition" : tfCasecontext.text!,"caseDiaryCount" : 1 ,"caseIncomes" : 0 ,"caseOutlays" : 0 ,"caseStaffs" : 0 ])
        var caseDiary = ""
        if tvCaseDiary.text! != "" && tvCaseDiary.text! != placeHolderText{
            caseDiary = tvCaseDiary.text!
        }
        db.collection("UserAccount").document("\(userId)").collection("Case").document("\(caseCount)").collection("caseDiary").document("1").setData(["caseDiaryid":"1" ,"date":newCase.date,"caseContent" : caseDiary ])
        
    }
    func creatOver(){
        if let activityIndicatorView = activityIndicatorView {
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.stopAnimating()
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func checkImage() {
        
        /* 如果下載進度還沒到最大值就顯示下載進度；下載完成就顯示"Download Finished" */
        if checkImage1 , checkImage2 , checkImage3 {
            /* 用%跳脫後面%，所以%%等於%文字。下載進度為0%~100%所以progressView的值乘以100 */
            
            timer?.invalidate()
            timer = nil
            creatOver()
        } else {
            
            
        }
    }
    func getCaseCount(){
        let db = Firestore.firestore()
        let doc = db.collection("UserAccount").document("\(userId)")
        doc.getDocument { (docSnapshot, error) in
            if let docSnapshot = docSnapshot {
                if docSnapshot.data() != nil {
                    caseCount = (docSnapshot.data()?["caseCount"] as! Int)
                    caseCount += 1
                    self.createCase()
                    if let image = self.ivAccount.image {
                        self.uploadPhoto(index: "1",image: image) { (url) in
                            
                            if let url = url {
                                self.newCase.imageUrl1 = url.absoluteString
                                let db = Firestore.firestore()
                                let data: [String: Any] = ["photoUrl1": url.absoluteString]
                                db.collection("UserAccount").document("\(userId)").collection("Case").document("\(caseCount)").updateData(data)
                                self.checkImage1 = true
                                
                            }
                        }
                    }else{
                        self.checkImage1 = true
                    }
                    if let image = self.ivAccount2.image {
                        self.uploadPhoto(index: "2",image: image) { (url) in
                            if let url = url {
                                self.newCase.imageUrl2 = url.absoluteString
                                let db = Firestore.firestore()
                                let data: [String: Any] = ["photoUrl2": url.absoluteString]
                                db.collection("UserAccount").document("\(userId)").collection("Case").document("\(caseCount)").updateData(data)
                                self.checkImage2 = true
                                
                            }
                        }
                    }else{
                        self.checkImage2 = true
                    }
                    
                    if let image = self.ivAccount3.image {
                        self.uploadPhoto(index: "3",image: image) { (url) in
                            if let url = url {
                                self.newCase.imageUrl3 = url.absoluteString
                                let db = Firestore.firestore()
                                let data: [String: Any] = ["photoUrl3": url.absoluteString]
                                db.collection("UserAccount").document("\(userId)").collection("Case").document("\(caseCount)").updateData(data)
                                self.checkImage3 = true
                            }
                        }
                    }else{
                        self.checkImage3 = true
                    }
                    if self.timer == nil {
                        /* 設定計時器不間斷地(repeats: true)每隔0.5秒鐘(timeInterval: 0.5)就透過現行物件(target: self)呼叫progressChanged方法(selector: #selector(progressChanged))一次 */
                        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.checkImage), userInfo: nil, repeats: true)
                    }
                }
            }
        }
    }
}

