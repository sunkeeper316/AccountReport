

import UIKit
import Firebase

class UpdataAccountTVC: UITableViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextViewDelegate{

    var checkImage = false
    var timer : Timer?
    var oneCase:Case!
    var account:Account!
    var keyWord : String?
    var date = Date()
    let calendar = Calendar.current
    var datecomponents : DateComponents?
    var completionHandler:((Account) -> Void)?
    var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var lbNoimage: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbClassAccount: UILabel!
    @IBOutlet weak var tfAccountName: UITextField!
    @IBOutlet weak var tfAccountNumber: UITextField!
    @IBOutlet weak var ivAccount: UIImageView!
    @IBOutlet weak var tvRemark: UITextView!
    var placeHolderText = "寫一些備註..."
    var image:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        if keyWord == "income" {
            title = "新增收入"
        }else if keyWord == "outlay" {
            title = "新增支出"
        }
        tvRemark.text = placeHolderText
        tvRemark.delegate = self
        tfAccountName.delegate = self
        
        setToolbar(tfAccountNumber)
        setToolbar(tvRemark)
        tfAccountNumber.tag = 1
        tfAccountName.inputView = nil
        if !incomes.isEmpty{
            lbClassAccount.text = incomes.first
        }
        
        if let account = account {
            datecomponents = DateComponents()
            datecomponents?.calendar = Calendar.current
            datecomponents!.day = account.day
            datecomponents!.year = account.year
            datecomponents!.month = account.month
            lbDate.text = "\(datecomponents!.year!).\(datecomponents!.month!).\(datecomponents!.day!)."
            tvRemark.textColor = .black
            tvRemark.text = account.accountRemark
            lbClassAccount.text = account.accountClass
            tfAccountName.text = account.accountName
            tfAccountNumber.text = "\(account.accountNumber ?? 0)"
            if account.imageUrl != nil , account.imageUrl != ""{
                lbNoimage.text = ""
                fetchImage(url: URL(string: account.imageUrl!)) { (image) in
                    DispatchQueue.main.async {
                        self.ivAccount.image = image
                        self.image = image
                        
                    }
                }
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tvRemark.textColor = .black

        if(self.tvRemark.text == placeHolderText) {
            self.tvRemark.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            self.tvRemark.text = placeHolderText
            self.tvRemark.textColor = .lightGray
        }
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NumberVC") as! NumberVC
            vc.infostring = textField.text!
            vc.completionHandler = {(inputtext) in
                textField.text = inputtext
            }
            self.present(vc, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TextfieldVC") as! TextfieldVC
            vc.infostring = tfAccountName.text!
            vc.keyword = "\(keyWord!)"
            vc.completionHandler = {(inputtext) in
                self.tfAccountName.text = inputtext
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        return false
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

    @IBAction func clickSave(_ sender: Any) {
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        if tfAccountName.text! != ""{
            account.year = datecomponents!.year!
            account.month = datecomponents!.month!
            account.day = datecomponents!.day!
            account.accountName = tfAccountName.text!
            account.accountClass = lbClassAccount.text!
            if tfAccountNumber.text! != "" {
                account.accountNumber = Double(tfAccountNumber.text!)
            }else{
                account.accountNumber = 0
            }
            if tvRemark.text != placeHolderText {
                account.accountRemark = tvRemark.text!
            }else{
                account.accountRemark = ""
            }
            updataAccount()
            
        }else{
            let alert = UIAlertController(title: "警告", message: "沒有輸入任何東西喔！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    //===================================照片============================================
    
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
                
            }else{
                ivAccount.image = pickedImage
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
    
    //===================================照片===============================================
    
    //===================================firebase
    func deleteImage(account:Account){
        if account.imageUrl != nil , account.imageUrl != "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_\(keyWord!)\(account.id!)" + ".jpg")
            fileReference.delete(completion: nil)
            let db = Firestore.firestore()
                let data: [String: Any] = ["photoUrl": ""]
            db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase.id!)").collection("\(keyWord!)").document("\(account.id!)").updateData(data)
        }
    }
    func uploadPhoto(image:UIImage,completion: @escaping (URL?) -> () ) {
        
        let imageIndex = account.id!
        let fileReference = Storage.storage().reference().child("user\(userId)_\(keyWord!)\(imageIndex)" + ".jpg")
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
    @objc func check() {
        
        /* 如果下載進度還沒到最大值就顯示下載進度；下載完成就顯示"Download Finished" */
        if checkImage {
            /* 用%跳脫後面%，所以%%等於%文字。下載進度為0%~100%所以progressView的值乘以100 */
            self.activityIndicatorView.stopAnimating()
            completionHandler!(account)
            navigationController?.popViewController(animated: true)
            timer?.invalidate()
            timer = nil
        } else {
            
            
        }
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
    func updataAccount(){
        let db = Firestore.firestore()
            let doc = db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase!.id!)")
            doc.collection("\(keyWord!)").document("\(account!.id!)").updateData([ "year" : account!.year , "month" : account!.month , "day" : account!.day ,"class" : account!.accountClass!,"Name" : account!.accountName!,"Number" : account!.accountNumber ?? 0,"remark" : account!.accountRemark!])
            if let image = self.ivAccount.image {
                self.uploadPhoto(image: image) { (url) in
                    
                    if let url = url {
                        self.account.imageUrl = url.absoluteString
                        let db = Firestore.firestore()
                        let data: [String: Any] = ["photoUrl": url.absoluteString]
                        db.collection("UserAccount").document("\(userId)").collection("Case").document("\(self.oneCase.id!)").collection("\(self.keyWord!)").document("\(self.account!.id!)").updateData(data)
                        self.checkImage = true
                    }
                }
            }else{
                
                deleteImage(account:self.account)
                self.account!.imageUrl = ""
                self.checkImage = true
            }
            if self.timer == nil {
                /* 設定計時器不間斷地(repeats: true)每隔0.5秒鐘(timeInterval: 0.5)就透過現行物件(target: self)呼叫progressChanged方法(selector: #selector(progressChanged))一次 */
                self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.check), userInfo: nil, repeats: true)
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AccountClass"{
                    let vc = segue.destination as! AccountPickerViewVC
                    if keyWord == "income" {
                        vc.segmentedIndex = 0
                    }else if keyWord == "outlay" {
                        vc.segmentedIndex = 1
                    }
                    
                    vc.identifier = "AccountClass"
                    vc.completionHandler = {(accountClass) in
                        self.lbClassAccount.text = accountClass
                    }
                }else if segue.identifier == "imageShow"{
                    let vc = segue.destination as! PageImageVC
                    let images : [UIImage]
                    if let image = image {
                        images = [image]
                        vc.images = images
                    }
                    
                    vc.completionHandler = {(currentPage) in
                        if currentPage == 0 {
                            self.ivAccount.image = nil
                            
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
    }
    

}
