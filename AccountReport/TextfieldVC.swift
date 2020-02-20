
import Firebase
import UIKit

class TextfieldVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    

    @IBOutlet weak var tfInput: UITextField!
    var completionHandler:((String) -> Void)?
    var infostring:String?
    var keyword:String?
    var keywordArray = [String]()
    var historicals = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar(tfInput)
        tfInput.text = infostring
        tfInput.becomeFirstResponder()
        if let keyword = keyword {
            if keyword == "CaseName" {
                for c in cases {
                    historicals.append(c.caseName!)
                }
                tableView.reloadData()
            }else if keyword == "staffJob" {
                let db = Firestore.firestore()
                db.collection("UserAccount").document("\(userId)").collection("Staff").getDocuments{ (docSnapshot, error) in
                    if let docs = docSnapshot?.documents {
                        var jobs = [String]()
                        for doc in docs {
                            let job  = ((doc.data()["Job"] ?? "") as! String)
                            jobs.append(job)
                            
                        }
                        self.historicals = jobs
                        self.tableView.reloadData()
                        
                    }
                }
            }else if keyword == "income" || keyword == "outlay"{
                let db = Firestore.firestore()
                
                
                db.collection("UserAccount").document("\(userId)").collection("Case").getDocuments{ (docSnapshot, error) in
                    if let docs = docSnapshot?.documents {
                        
                        var ids = [String]()
                        for doc in docs {
                            
                            let id = doc.documentID
                            ids.append(id)
                            
                        }
                        for id in ids {
                            db.collection("UserAccount").document("\(userId)").collection("Case").document("\(id)").collection("\(keyword)").getDocuments { (docSnapshot, error) in
                                if let docs = docSnapshot?.documents{
                                    var names = [String]()
                                    for doc in docs {
                                        let name = ((doc.data()["Name"] ?? "") as! String)
                                        names.append(name)
                                    }
                                    self.historicals = names
                                    self.tableView.reloadData()
                                }

                                
                            }
                        }
                        
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setToolbar(_ textFeild:UITextField){
        let toolBarHeight:CGFloat = 150
        //製作鍵盤上方幫手
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: toolBarHeight))
        //左邊空白處
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //想製作的按鈕及用途
        let doneBotton: UIBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(doneButtonAction))
        toolBar.setItems([flexSpace,doneBotton], animated: false)
        toolBar.sizeToFit()
        textFeild.inputAccessoryView = toolBar
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
        completionHandler!(tfInput.text!)
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historicals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let historical = historicals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell")!
        cell.textLabel?.text = historical
        cell.imageView?.image = UIImage(named: "clock")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historical = historicals[indexPath.row]
        tfInput.text = historical
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
