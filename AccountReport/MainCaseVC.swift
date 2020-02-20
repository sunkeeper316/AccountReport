
import UIKit
import Firebase

class MainCaseVC: UIViewController ,UITableViewDataSource , UITableViewDelegate{
    var activityIndicatorView: UIActivityIndicatorView!
    var caseShow : Case?
    var caseShows = [Case]()
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadfirst()
        getAllpicker()
        if !isnofirst {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.in
            self.performSegue(withIdentifier: "LoginTVC", sender: self)
            
        }
        getAllCase()
//        getUserCount()
        
        //        segmented.selectedSegmentIndex = 0
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCaseshow()
        tableView.reloadData()
        
    }
    
    func setCaseshow(){
        switch segmented.selectedSegmentIndex {
        case 0:
            caseShows = cases
            tableView.reloadData()
        case 1:
            caseShows.removeAll()
            for c in cases {
                if c.isMark {
                    caseShows.append(c)
                }
            }
            tableView.reloadData()
            
        case 2:
            caseShows.removeAll()
            for c in cases {
                if !c.isMark {
                    caseShows.append(c)
                }
            }
            
            tableView.reloadData()
        default:
            break
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        caseShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let caseShow = caseShows[indexPath.row]
        let calendar = Calendar.current
        let datecomponents = calendar.dateComponents([.year,.month,.day], from: caseShow.date)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCaseCell") as! MainCaseCell
        cell.lbName.text = caseShow.caseName
        if caseShow.isMark {
            cell.ivStar.image = UIImage(named: "starfull")
        }else{
            cell.ivStar.image = UIImage(named: "starclear")
        }
        
        cell.lbDate.text = "\(datecomponents.year!).\(datecomponents.month!).\(datecomponents.day!)"
        return cell
    }
    
    // 左滑修改與刪除資料
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 左滑時顯示Edit按鈕
        let edit = UITableViewRowAction(style: .default, title: "編輯", handler: { (action, indexPath) in
            self.caseShow = self.caseShows[indexPath.row]
            self.performSegue(withIdentifier: "CaseUpdate", sender: nil)
        })
        edit.backgroundColor = UIColor.lightGray
        
        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "刪除", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "警告", message: "刪除後全部資料都會刪除！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                for (index,c) in cases.enumerated() {
                    if self.caseShows[indexPath.row].id == c.id{
                        cases.remove(at: index)
                        
                    }
                }
                let oneCase = self.caseShows[indexPath.row]
                self.caseShows.remove(at: indexPath.row)
                self.deleteCase(oneCase: oneCase)
                self.deleteImage(oneCase: oneCase)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion:nil)
            
        })
        return [delete, edit]
    }
    func deleteCase(oneCase:Case){
        let db = Firestore.firestore()
        
        for i in 1...oneCase.caseDiaryCount! {
            db.collection("UserAccount").document("\(userId)").collection("Case").document(oneCase.id!).collection("caseDiary").document("\(i)").delete()
        }
        
            db.collection("UserAccount").document("\(userId)").collection("Case").document(oneCase.id!).delete()
        
    }
    func deleteImage(oneCase : Case){
        if oneCase.imageUrl1 != nil , oneCase.imageUrl1 != "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_case\(oneCase.id!)_1" + ".jpg")
            fileReference.delete(completion: nil)
        }
        if oneCase.imageUrl2 != nil , oneCase.imageUrl2 != "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_case\(oneCase.id!)_2" + ".jpg")
            fileReference.delete(completion: nil)
        }
        if oneCase.imageUrl3 != nil , oneCase.imageUrl3 != "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_case\(oneCase.id!)_3" + ".jpg")
            fileReference.delete(completion: nil)
        }
    }
    
    @IBAction func clickSegmented(_ sender: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        case 0:
            caseShows = cases
            tableView.reloadData()
        case 1:
            caseShows.removeAll()
            for c in cases {
                if c.isMark {
                    caseShows.append(c)
                }
            }
            tableView.reloadData()
            
        case 2:
            caseShows.removeAll()
            for c in cases {
                if !c.isMark {
                    caseShows.append(c)
                }
            }
            tableView.reloadData()
        default:
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CaseDetail"{
            let indexPath = tableView.indexPathForSelectedRow
            let tagetCase = caseShows[indexPath!.row]
            let nc = segue.destination as! CaseDetailNC
            let vc = nc.topViewController as! CaseDetailTVC
            vc.oneCase = tagetCase
            
        }else if segue.identifier == "CaseUpdate" {
            //            let indexPath = tableView.indexPathForSelectedRow
            //            let tagetCase = cases[indexPath!.row]
            let nc = segue.destination as! CaseUpdateNC
            let vc = nc.topViewController as! CaseUpdateTVC
            vc.oneCase = caseShow
        }
    }
    func getAllCase(){
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
        let db = Firestore.firestore()
        db.collection("UserAccount").document("\(userId)").collection("Case").getDocuments { (docSnapshot, error) in
            if let docs = docSnapshot?.documents {
                var newCases = [Case]()
                for doc in docs {
                    let oneCase = Case()
                    oneCase.caseName = (doc.data()["caseName"] as! String)
                    oneCase.caseClass = ((doc.data()["caseClass"] ?? "") as! String)
                    oneCase.id = ((doc.data()["caseid"] ?? "") as! String)
                    oneCase.casePosition = ((doc.data()["casePosition"] ?? "") as! String)
                    oneCase.imageUrl1 = ((doc.data()["photoUrl1"] ?? "") as! String)
                    oneCase.imageUrl2 = ((doc.data()["photoUrl2"] ?? "") as! String)
                    oneCase.imageUrl3 = ((doc.data()["photoUrl3"] ?? "") as! String)
                    let t = ((doc.data()["date"]!) as! Timestamp)
                    oneCase.date = Date(timeIntervalSince1970: TimeInterval(integerLiteral: t.seconds))
                    oneCase.caseDiaryCount = ((doc.data()["caseDiaryCount"] ?? 0) as! Int)
                    oneCase.caseIncomes = ((doc.data()["caseIncomes"] ?? 0) as! Int)
                    oneCase.caseOutlays = ((doc.data()["caseOutlays"] ?? 0) as! Int)
                    oneCase.caseStaffs = ((doc.data()["caseStaffs"] ?? 0) as! Int)
                    oneCase.isMark = ((doc.data()["isMark"] ?? false) as! Bool)
                    newCases.append(oneCase)
                }
                cases = newCases
                self.activityIndicatorView.stopAnimating()
                self.setCaseshow()
            }
        }
    }
    
    func getAllpicker(){
        let db = Firestore.firestore()
        db.collection("UserAccount").document("\(userId)").getDocument { (docSnapshot, error) in
            if let docSnapshot = docSnapshot {
                caseClasses = docSnapshot.data()?["caseClasses"] as! [String]
                incomes = docSnapshot.data()?["incomes"] as! [String]
                outlays = docSnapshot.data()?["caseClasses"] as! [String]
            }
        }
    }
    
    func getUserCount(){
        let db = Firestore.firestore()
        let doc = db.collection("UserAccount").document("user")
        doc.getDocument { (docSnapshot, error) in
            if let docSnapshot = docSnapshot {
                if docSnapshot.data() != nil {
                    userCount = (docSnapshot.data()?["UserAccount"] as! Int)
                    self.setUser()
                }
            }
        }
    }
    func setUser(){
        let db = Firestore.firestore()
        let doc = db.collection("UserAccount").document("user")
        userCount += 1
        doc.setData(["UserAccount" : userCount])
        doc.collection("\(userCount)").document("AccountId").setData(["Id":"\(userCount)"])
        
    }
    
}

