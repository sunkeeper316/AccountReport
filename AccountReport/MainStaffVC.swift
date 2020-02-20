import Firebase
import UIKit

class MainStaffVC: UIViewController ,UITableViewDataSource , UITableViewDelegate{
    
    var staff : Staff?
    var staffs = [Staff]()
    var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllStaff()
        title = "員工"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        staffs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffCell") as! StaffCell
        let staff = staffs[indexPath.row]
        cell.lbStaffName.text = "姓名：\(staff.staffName ?? "")"
        cell.lbStaffJob.text = "工作：\(staff.staffJob ?? "")"
        cell.lbStaffPhone.text = "電話：\(staff.staffphone ?? "")"
        cell.lbStaffRemark.text = staff.staffRemark
        let calendar = Calendar.current
        let datecomponents = calendar.dateComponents([.day ,.month,.year], from: staff.startDate!)
        cell.lbStaffStartDate.text = "開始工作\(datecomponents.year!).\(datecomponents.month!).\(datecomponents.day!)"
        cell.btStaff.setImage(UIImage(named: "noImage"), for: .normal)
        if let imageUrl = staff.imageUrl , staff.imageUrl != nil , staff.imageUrl != ""{
            fetchImage(url: URL(string: imageUrl)) { (image) in
                DispatchQueue.main.async {
                    if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                        cell.btStaff.setImage(image, for: .normal)
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 左滑時顯示Edit按鈕
        let edit = UITableViewRowAction(style: .default, title: "編輯", handler: { (action, indexPath) in
            self.staff = self.staffs[indexPath.row]
            self.performSegue(withIdentifier: "staffUpdate", sender: nil)
        })
        edit.backgroundColor = UIColor.lightGray
        
        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "刪除", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "警告", message: "刪除後全部資料都會刪除！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
//                for (index,s) in self.staffs.enumerated() {
//                    if self.staffs[indexPath.row].id == s.id{
//                        self.staffs.remove(at: index)
//
//                    }
//                }
                let staff = self.staffs[indexPath.row]
                self.staffs.remove(at: indexPath.row)
                self.deleteStaff(staff: staff)
                self.deleteImage(staff: staff)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion:nil)
            
        })
        return [delete, edit]
    }
    func getAllStaff(){
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        let db = Firestore.firestore()
        db.collection("UserAccount").document("\(userId)").collection("Staff").getDocuments { (docSnapshot, error) in
            if let docs = docSnapshot?.documents {
                var staffs = [Staff]()
                for doc in docs {
                    let staff = Staff()
                    staff.id = doc.documentID
                    staff.staffName = (doc.data()["Name"] as! String)
                    staff.staffJob = ((doc.data()["Job"] ?? "") as! String)
                    staff.staffphone = ((doc.data()["Phone"] ?? "") as! String)
                    staff.imageUrl = ((doc.data()["photoUrl"] ?? "") as! String)
                    let t = ((doc.data()["StartDate"]!) as! Timestamp)
                    staff.startDate = Date(timeIntervalSince1970: TimeInterval(integerLiteral: t.seconds))
                    staff.moneyType = ((doc.data()["PayType"] ?? "") as! String)
                    staff.staffpay = ((doc.data()["Pay"] ?? 0) as! Double)
                    staff.staffRemark = ((doc.data()["Remark"] ?? "") as! String)
                    staffs.append(staff)
                }
                self.staffs = staffs
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
                
            }
        }
    }
    func deleteStaff(staff:Staff){
        let db = Firestore.firestore()
        
//        for i in 1...oneCase.caseDiaryCount! {
//            db.collection("UserAccount").document("\(userId)").collection("Case").document(oneCase.id!).collection("caseDiary").document("\(i)").delete()
//        }
        
            db.collection("UserAccount").document("\(userId)").collection("Staff").document(staff.id!).delete()
        
    }
    func deleteImage(staff : Staff){
        if staff.imageUrl != nil , staff.imageUrl != "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_staff_\(staff.id!)" + ".jpg")
            fileReference.delete(completion: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "staffAdd"{
            
            let nc = segue.destination as! StaffInsertNC
            let vc = nc.topViewController as! InsertStaffTVC
            vc.completionHandler = {(staff) in
                self.staffs.append(staff)
                self.tableView.reloadData()
            }
            
        }else if segue.identifier == "staffUpdate"{
            
            let nc = segue.destination as! StaffUpdateNC
            let vc = nc.topViewController as! UpdateStaffTVC
            vc.staff = staff
            vc.completionHandler = {(staff) in
                for s in self.staffs{
                    if s.id == staff.id {
                        s.staffName = staff.staffName
                        s.staffJob = staff.staffJob
                        s.staffphone = staff.staffphone
                        s.imageUrl = staff.imageUrl
                        s.startDate = staff.startDate
                        s.moneyType = staff.moneyType
                        s.staffpay = staff.staffpay
                        s.staffRemark = staff.staffRemark
                        break
                    }
                }
                self.tableView.reloadData()
            }
            
        }else if segue.identifier == "staffDetail"{
            
            let nc = segue.destination as! StaffDetailNC
            let vc = nc.topViewController as! DetailStaffTVC
            let indexpath = tableView.indexPathForSelectedRow
            let staff = staffs[indexpath!.row]
            vc.staff = staff
            
        }
    }
    

}
