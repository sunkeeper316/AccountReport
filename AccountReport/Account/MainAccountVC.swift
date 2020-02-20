
import UIKit
import Firebase

class MainAccountVC: UIViewController ,UITableViewDataSource , UITableViewDelegate{
    
    var accounts = [Account]()

    var oneCase : Case?
    var keyWord : String?
    var completionHandler:(([Account],Case) -> Void)?
    var index :Int?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if keyWord == "income" {
            title = "收入"
        }else if keyWord == "outlay" {
            title = "支出"
        }

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        let account = accounts[indexPath.row]
        if keyWord == "income" {
            cell.lbAccountNumber.textColor = .blue
        }else if keyWord == "outlay" {
            cell.lbAccountNumber.textColor = .red
        }
        cell.lbAccountClass.text = account.accountClass
        cell.lbAccountName.text = account.accountName
        cell.lbAccountNumber.text = "\(account.accountNumber ?? 0.0)"
        cell.lbAccountRemarker.text = account.accountRemark
        cell.lbDate.text = "\(account.year).\(account.month).\(account.day)"
        cell.btAccountImage.setImage(UIImage(named: "noImage"), for: .normal)
        
        if let imageUrl = account.imageUrl , account.imageUrl != nil , account.imageUrl != ""{
            fetchImage(url: URL(string: imageUrl)) { (image) in
                DispatchQueue.main.async {
                    if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                        cell.btAccountImage.setImage(image, for: .normal)
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "刪除", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "警告", message: "刪除後全部資料都會刪除！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                let account = self.accounts[indexPath.row]
                self.accounts.remove(at: indexPath.row)
                self.completionHandler!(self.accounts,self.oneCase!)
                self.deleteAccount(account: account)
                self.deleteImage(account:account)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion:nil)
            
        })
        return [delete]
    }
    func deleteAccount(account:Account){
        let db = Firestore.firestore()
        let doc = db.collection("UserAccount").document("\(userId)").collection("Case").document("\(self.oneCase!.id!)")
        if keyWord == "income" {
            doc.collection("\(keyWord!)").document("\(account.id!)").delete()
        }else if keyWord == "outlay" {
            doc.collection("\(keyWord!)").document("\(account.id!)").delete()
        }
        
        
    }
    func deleteImage(account:Account){
        if account.imageUrl != nil , account.imageUrl != "" {
            let fileReference = Storage.storage().reference().child("user\(userId)_\(keyWord!)\(account.id!)" + ".jpg")
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
        if segue.identifier == "InsertAccount"{
           let vc = segue.destination as! InsertAccountTVC
            vc.oneCase = oneCase
            vc.keyWord = keyWord!
            vc.completionHandler = {(account) in
                if self.keyWord == "income" {
                    self.oneCase!.caseIncomes = self.oneCase!.caseIncomes!+1
                    
                    self.accounts.append(account)
                }else if self.keyWord == "outlay" {
                    self.oneCase!.caseOutlays = self.oneCase!.caseOutlays!+1
                    
                    self.accounts.append(account)
                }
                self.tableView.reloadData()
                self.completionHandler!(self.accounts,self.oneCase!)
            }
        }else if segue.identifier == "UpdataAccount" {
            let vc = segue.destination as! UpdataAccountTVC
            vc.oneCase = oneCase
            vc.keyWord = keyWord!
            let indexpath = tableView.indexPathForSelectedRow
            let account = accounts[indexpath!.row]
            vc.account = account
            vc.completionHandler = {(account) in
                for a in self.accounts{
                    if a.id == account.id{
                        a.year = account.year
                        a.month = account.month
                        a.day = account.day
                        a.accountName = account.accountName
                        a.accountClass = account.accountClass
                        a.accountRemark = account.accountRemark
                        a.accountNumber = account.accountNumber
                        a.imageUrl = account.imageUrl
                        print(a.imageUrl ?? 000)
                    }
                }
                self.tableView.reloadData()
                self.completionHandler!(self.accounts,self.oneCase!)
            }
        }else if segue.identifier == "imageShow"{
            let vc = segue.destination as! PageImageVC
            vc.isDetail = true
            let bt = sender as! UIButton
            let images : [UIImage]
            if let image = bt.image(for: .normal){
                images = [image]
                vc.images = images
            }
        }
    }
    

}
