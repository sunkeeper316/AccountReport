
import Firebase
import UIKit

class UpdateStaffTVC: UITableViewController ,UITextFieldDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITextViewDelegate{

    var staff:Staff?
    var staffs = [Staff]()
    var timer : Timer?
    var checkImage = false
    var placeHolderText = "寫一些備註..."
    var image:UIImage?
    var date = Date()
    let calendar = Calendar.current
    var datecomponents : DateComponents?
    var activityIndicatorView: UIActivityIndicatorView!
    var completionHandler:((Staff) -> Void)?
    @IBOutlet weak var ivStaff: UIImageView!
    @IBOutlet weak var tfStaffName: UITextField!
    @IBOutlet weak var tfStaffJob: UITextField!
    @IBOutlet weak var tfStaffPhone: UITextField!
    @IBOutlet weak var lbStaffStartDate: UILabel!
    @IBOutlet weak var lbStaffPayType: UILabel!
    @IBOutlet weak var tfStaffPay: UITextField!
    @IBOutlet weak var tvStaffRemark: UITextView!
    @IBOutlet weak var lbNoImage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新增員工"
        tvStaffRemark.text = placeHolderText
        tfStaffJob.delegate = self
        
        tvStaffRemark.delegate = self
        
        tfStaffJob.tag = 2
        setToolbar(tfStaffName)
        setToolbar(tfStaffPhone)
        setToolbar(tfStaffJob)
        setToolbar(tvStaffRemark)
        setToolbar(tfStaffPay)
        if let staff = staff {
            datecomponents = DateComponents()
            datecomponents?.calendar = Calendar.current
            date = staff.startDate!
            datecomponents = calendar.dateComponents([.day ,.month,.year], from: date)
            lbStaffStartDate.text = "\(datecomponents!.year!).\(datecomponents!.month!).\(datecomponents!.day!)."
            tvStaffRemark.textColor = .black
            lbStaffPayType.text = staff.moneyType
            tvStaffRemark.text = staff.staffRemark
            tfStaffJob.text = staff.staffJob
            tfStaffPhone.text = staff.staffphone
            tfStaffName.text = staff.staffName
            tfStaffPay.text = "\(staff.staffpay ?? 0)"
            if staff.imageUrl != nil , staff.imageUrl != ""{
                lbNoImage.text = ""
                fetchImage(url: URL(string: staff.imageUrl!)) { (image) in
                    DispatchQueue.main.async {
                        self.ivStaff.image = image
                        self.image = image
                        
                    }
                }
            }
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
        }else if textField.tag == 2{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TextfieldVC") as! TextfieldVC
            vc.infostring = tfStaffJob.text!
            vc.keyword = "staffJob"
            vc.completionHandler = {(inputtext) in
                self.tfStaffJob.text = inputtext
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        return false
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.tvStaffRemark.textColor = .black
        if(self.tvStaffRemark.text == placeHolderText) {
            self.tvStaffRemark.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            self.tvStaffRemark.text = placeHolderText
            self.tvStaffRemark.textColor = .lightGray
        }
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
    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickSave(_ sender: Any) {
        if tfStaffName.text! != "" {
            activityIndicatorView = UIActivityIndicatorView(style: .gray)
            view.addSubview(activityIndicatorView)
            activityIndicatorView.center = view.center
            activityIndicatorView.startAnimating()
            staff!.startDate = date
            staff!.staffName = tfStaffName.text!
            staff!.staffJob = tfStaffJob.text!
            staff!.staffpay = Double(tfStaffPay.text!)
            staff!.moneyType = lbStaffPayType.text!
            staff!.staffphone = tfStaffPhone.text!
            if tvStaffRemark.text != placeHolderText {
                staff!.staffRemark = tvStaffRemark.text!
            }else{
                staff!.staffRemark = ""
            }
            updateStaff()
            
        }else{
            let alert = UIAlertController(title: "警告", message: "沒有輸入任何東西喔！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion:nil)
        }
    }
    //===================================照片============================================
    @IBAction func clickImage(_ sender: UIButton) {
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
            if ivStaff.image == nil {
                ivStaff.image = pickedImage
                
            }else{
                ivStaff.image = pickedImage
            }
            
            image = pickedImage
            UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        }
        lbNoImage.text = ""
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    //===================================照片============================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PayType"{
                    let vc = segue.destination as! AccountPickerViewVC
                    
                    vc.identifier = "PayType"
                    vc.completionHandler = {(PayType) in
                        self.lbStaffPayType.text = PayType
                    }
                }else if segue.identifier == "imageShow"{
                    let vc = segue.destination as! PageImageVC
                    let images : [UIImage]
                    if let image = image {
                        images = [image]
                        vc.images = images
                    }
                    
                    vc.completionHandler = {(currentPage) in
        //                self.images.remove(at: currentPage)
                        if currentPage == 0 {
                            self.ivStaff.image = nil
                            self.lbNoImage.text = "沒有照片"
                            
                        }
                    }
                }else if segue.identifier == "datepicker"{
                    let vc = segue.destination as! DatePickerVC
                    vc.date = date
                    vc.completionHandler = {(date) in
                        self.date = date
                        self.datecomponents = self.calendar.dateComponents([.day ,.month,.year], from: date)
                        self.lbStaffStartDate.text = "\(self.datecomponents!.year!).\(self.datecomponents!.month!).\(self.datecomponents!.day!)"
                    }
                }
    }
    //===================================firebase=======================================
    func updateStaff(){
        let db = Firestore.firestore()
        let doc = db.collection("UserAccount").document("\(userId)").collection("Staff").document("\(staff!.id!)")
        doc.updateData(["StartDate":date,
                     "Name":staff!.staffName!,
                     "Job":staff!.staffJob!,
                     "Pay":staff!.staffpay ?? 0,
                     "PayType":staff!.moneyType!,
                     "Phone":staff!.staffphone!,
                     "Remark":staff!.staffRemark!])
        if let image = self.ivStaff.image {
            self.uploadPhoto(image: image) { (url) in
                
                if let url = url {
                    self.staff!.imageUrl = url.absoluteString
                    let db = Firestore.firestore()
                    let data: [String: Any] = ["photoUrl": url.absoluteString]
                    db.collection("UserAccount").document("\(userId)").collection("Staff").document("\(self.staff!.id!)").updateData(data)
                    self.checkImage = true
                    
                }
            }
        }else{
            deleteImage(staff:self.staff!)
            self.staff!.imageUrl = ""
            self.checkImage = true
        }
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.check), userInfo: nil, repeats: true)
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
    func deleteImage(staff:Staff){
        if staff.imageUrl != nil , staff.imageUrl != "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_staff_\(staff.id!)" + ".jpg")
            fileReference.delete(completion: nil)
            let db = Firestore.firestore()
                let data: [String: Any] = ["photoUrl": ""]
            db.collection("UserAccount").document("\(userId)").collection("Staff").document("\(staff.id!)").updateData(data)
        }
    }
    func uploadPhoto(image:UIImage,completion: @escaping (URL?) -> () ) {
        
        let fileReference = Storage.storage().reference().child("user\(userId)_staff_\(staff!.id!)" + ".jpg")
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
            completionHandler!(staff!)
            dismiss(animated: true, completion: nil)
            timer?.invalidate()
            timer = nil
        } else {
            
            
        }
    }
}
