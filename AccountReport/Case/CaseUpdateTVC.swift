
import Firebase
import UIKit

class CaseUpdateTVC: UITableViewController ,UITextViewDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextFieldDelegate{

    var oneCase : Case?
    var timer: Timer?
    var checkImage1 = false
    var checkImage2 = false
    var checkImage3 = false
    var clickImage = false
    var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var tfCaseName: UITextField!
    @IBOutlet weak var tfCasecontext: UITextField!
    @IBOutlet weak var lbNoimage: UILabel!
    @IBOutlet weak var ivAccount: UIImageView!
    @IBOutlet weak var ivAccount2: UIImageView!
    @IBOutlet weak var ivAccount3: UIImageView!
    @IBOutlet weak var activity1: UIActivityIndicatorView!
    @IBOutlet weak var activity2: UIActivityIndicatorView!
    @IBOutlet weak var activity3: UIActivityIndicatorView!
    var placeHolderText = "寫一些備註..."
    var newCase:Case!
    var images = [UIImage]()
    var image1:UIImage?
    var image2:UIImage?
    var image3:UIImage?
   
    var date = Date()
    let calendar = Calendar.current
    var datecomponents : DateComponents?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "案件修改"
        activity1.hidesWhenStopped = true
        activity2.hidesWhenStopped = true
        activity3.hidesWhenStopped = true
        tfCasecontext.tag = 1
        tfCasecontext.delegate = self
        tfCaseName.delegate = self
        
        setToolbar(tfCaseName)
        setToolbar(tfCasecontext)
        if let oneCase = oneCase {
            tfCaseName.text = oneCase.caseName
            tfCasecontext.text = oneCase.casePosition
            date = oneCase.date
            datecomponents = calendar.dateComponents([.year,.month,.day], from: oneCase.date)
            lbDate.text = "\(datecomponents!.year!).\(datecomponents!.month!).\(datecomponents!.day!)"
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
            
            if let casePosition = oneCase.casePosition {
                tfCasecontext.text = casePosition
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

    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSave(_ sender: UIBarButtonItem) {
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        if let oneCase = oneCase {
            for c in cases {
                if oneCase.id == c.id {
                    c.caseName = tfCaseName.text!
                    c.casePosition = tfCasecontext.text!
                    c.date = date
                    if clickImage {
                        imageUpload(oneCase: c)
                        deleteImage(oneCase : c)
                    }else{
                        updataCase()
                    }
                    break
                }
            }
//            if tfCaseName.text! != ""{
//                oneCase.caseName = tfCaseName.text!
//
//                if tfCasecontext.text! != ""{
//                    oneCase.casePosition = tfCasecontext.text!
//                }
//                oneCase.year = datecomponents!.year!
//                oneCase.month = datecomponents!.month!
//                oneCase.day = datecomponents!.day!
//
//                dismiss(animated: true, completion: nil)
//            }
            
            
        }
    }
    //=======================================================================
    
    @IBAction func clickImage(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let pickpic = UIAlertAction(title: "相簿", style: .default) { (alertAction) in
            self.clickImage = true
            let imagePicker = UIImagePickerController()
            /* 將UIImagePickerControllerDelegate、UINavigationControllerDelegate物件指派給UIImagePickerController */
            imagePicker.delegate = self
            /* 照片來源為相簿 */
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let takepic = UIAlertAction(title: "拍照", style:.default) { (alertAction) in
            self.clickImage = true
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

                images.removeAll()
                images.append(ivAccount.image!)
                images.append(ivAccount2.image!)
                images.append(ivAccount3.image!)
                images.remove(at: 0)
                images.insert(pickedImage, at: 0)
            }
            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        }
        lbNoimage.text = ""
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    //=======================================================================
    @objc func checkImage() {
        if checkImage1 , checkImage2 , checkImage3 {
            updataCase()
            timer?.invalidate()
            timer = nil
        }
    }
    func uploadPhoto(index:String,image:UIImage,completion: @escaping (URL?) -> () ) {
        
        //        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        let fileReference = Storage.storage().reference().child("user\(userId)_case\(oneCase!.id!)_\(index)" + ".jpg")
        let size = CGSize(width: 640, height:image.size.height * 640 / image.size.width)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let data = resizeImage?.jpegData(compressionQuality: 0.5) {
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
    func imageUpload(oneCase : Case){
        if let image = self.ivAccount.image {
            self.uploadPhoto(index: "1",image: image) { (url) in
                
                if let url = url {
                    oneCase.imageUrl1 = url.absoluteString
                    let db = Firestore.firestore()
                    let data: [String: Any] = ["photoUrl1": url.absoluteString]
                    db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase.id!)").updateData(data)
                    self.checkImage1 = true
                    
                }
            }
        }else{
            self.checkImage1 = true
        }
        if let image = self.ivAccount2.image {
            self.uploadPhoto(index: "2",image: image) { (url) in
                if let url = url {
                    oneCase.imageUrl2 = url.absoluteString
                    let db = Firestore.firestore()
                    let data: [String: Any] = ["photoUrl2": url.absoluteString]
                    db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase.id!)").updateData(data)
                    self.checkImage2 = true
                    
                }
            }
        }else{
            self.checkImage2 = true
        }
        
        if let image = self.ivAccount3.image {
            self.uploadPhoto(index: "3",image: image) { (url) in
                if let url = url {
                    oneCase.imageUrl3 = url.absoluteString
                    let db = Firestore.firestore()
                    let data: [String: Any] = ["photoUrl3": url.absoluteString]
                    db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase.id!)").updateData(data)
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
    func updataCase(){
        let db = Firestore.firestore()
        
        let doc = db.collection("UserAccount").document("\(userId)").collection("Case").document(oneCase!.id!)
        doc.updateData([ "caseName" : "\(tfCaseName.text!)" ,"date":date , "casePosition" : tfCasecontext.text! ])
        activityIndicatorView.stopAnimating()
        dismiss(animated: true, completion: nil)
    }
    func deleteImage(oneCase : Case){
        if oneCase.imageUrl1 == nil || oneCase.imageUrl1 == "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_case\(oneCase.id!)_1" + ".jpg")
            fileReference.delete(completion: nil)
            let db = Firestore.firestore()
            let data: [String: Any] = ["photoUrl1": ""]
        db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase.id!)").updateData(data)
        }
        if oneCase.imageUrl2 == nil || oneCase.imageUrl2 == "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_case\(oneCase.id!)_2" + ".jpg")
            fileReference.delete(completion: nil)
            let db = Firestore.firestore()
                let data: [String: Any] = ["photoUrl2": ""]
        db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase.id!)").updateData(data)
        }
        if oneCase.imageUrl3 == nil || oneCase.imageUrl3 == "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_case\(oneCase.id!)_3" + ".jpg")
            
            fileReference.delete(completion: nil)
            let db = Firestore.firestore()
                let data: [String: Any] = ["photoUrl3": ""]
            db.collection("UserAccount").document("\(userId)").collection("Case").document("\(oneCase.id!)").updateData(data)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "imageShow"{
            images.removeAll()
            if oneCase?.imageUrl1 != nil && image1 != nil {
                images.append(image1!)
                if oneCase?.imageUrl2 != nil && image2 != nil {
                    images.append(image2!)
                    if oneCase?.imageUrl3 != nil && image3 != nil {
                        images.append(image3!)
                    }
                }
                let vc = segue.destination as! PageImageVC
                
                vc.images = images
                vc.completionHandler = {(currentPage) in
                    self.images.remove(at: currentPage)
                    self.clickImage = true
                    //                print("currentPage\(currentPage)")
                    if currentPage == 0 {
                        self.ivAccount.image = nil
                        self.ivAccount.image = self.ivAccount2.image
                        self.ivAccount2.image = self.ivAccount3.image
                        self.ivAccount3.image = nil
                        self.oneCase!.imageUrl1 = self.oneCase!.imageUrl2
                        self.oneCase!.imageUrl2 = self.oneCase!.imageUrl3
                        self.oneCase!.imageUrl3 = nil
                    }else if currentPage == 1 {
                        self.ivAccount2.image = nil
                        self.ivAccount2.image = self.ivAccount3.image
                        self.ivAccount3.image = nil
                        self.oneCase!.imageUrl2 = self.oneCase!.imageUrl3
                        self.oneCase!.imageUrl3 = nil
                    }else if currentPage == 2 {
                        self.ivAccount3.image = nil
                        self.oneCase!.imageUrl3 = nil
                    }
                }
            }
            }else if segue.identifier == "datepicker"{
                let vc = segue.destination as! DatePickerVC
                vc.date = date
                vc.completionHandler = {(date) in
                    self.date = date
                    self.datecomponents = self.calendar.dateComponents([.day ,.month,.year], from: date)
                    self.lbDate.text = "\(self.datecomponents!.year!)年\(self.datecomponents!.month!)月\(self.datecomponents!.day!)日"
                }
            }
//        else if segue.identifier == "caseClass"{
//                let vc = segue.destination as! AccountPickerViewVC
//                //            vc.segmentedIndex = segmented.selectedSegmentIndex
//                vc.identifier = "AccountClass"
//                vc.infostring = lbCaseClass.text!
//                vc.completionHandler = {(caseClass) in
//                    self.lbCaseClass.text = caseClass
//                }
//            }
            
        }
}
