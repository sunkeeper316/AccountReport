
import Firebase
import UIKit

class MainDiaryVC: UIViewController ,UITableViewDataSource , UITableViewDelegate{
    var caseDiarys = [CaseDiary]()
    var oneCase : Case?
    var textHeights = [CGFloat]()
    var completionHandler:(([CaseDiary]) -> Void)?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return caseDiarys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let caseDiary = caseDiarys[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        let calendar = Calendar.current
        let datecomponents = calendar.dateComponents([.year,.month,.day], from: caseDiary.date)
        cell.lbDiaryDate.text = "\(datecomponents.year!).\(datecomponents.month!).\(datecomponents.day!)"
        cell.lbDiaryContent.text = caseDiary.content
//        let height = cell.lbDiaryContent.frame.height
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 左滑時顯示Delete按鈕
        let delete = UITableViewRowAction(style: .destructive, title: "刪除", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "警告", message: "刪除後全部資料都會刪除！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                let oneDiary = self.caseDiarys[indexPath.row]
                self.caseDiarys.remove(at: indexPath.row)
                self.completionHandler!(self.caseDiarys)
                self.deleteDiary(CaseDiary: oneDiary)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion:nil)
            
        })
        return [delete]
    }
    
    func deleteDiary(CaseDiary:CaseDiary){
        let db = Firestore.firestore()
        let doc = db.collection("UserAccount").document("\(userId)").collection("Case").document("\(self.oneCase!.id!)")
        doc.collection("caseDiary").document("\(CaseDiary.id!)").delete()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "insertDiary" {
            let vc = segue.destination as! InsertDiaryTVC
            vc.oneCase = oneCase
            vc.completionHandler = {(caseDiary)in
                self.caseDiarys.append(caseDiary)
                self.tableView.reloadData()
                self.completionHandler!(self.caseDiarys)
            }
        }else if segue.identifier == "updatetDiary" {
            let vc = segue.destination as! UpdateDiaryTVC
            let indexpath = tableView.indexPathForSelectedRow
            let oneDiary = caseDiarys[indexpath!.row]
            vc.oneCase = oneCase
            vc.oneDiary = oneDiary
            vc.completionHandler = {(caseDiary)in
                for diary in self.caseDiarys {
                    if diary.id == caseDiary.id{
                        diary.date = caseDiary.date
                        diary.content = caseDiary.content
                    }
                }
                self.tableView.reloadData()
                self.completionHandler!(self.caseDiarys)
            }
        }
    }
    

}
