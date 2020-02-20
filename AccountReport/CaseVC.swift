//
//  CaseVC.swift
//  AccountReport
//
//  Created by 黃德桑 on 2019/11/23.
//  Copyright © 2019 sun. All rights reserved.
//

import UIKit

class CaseVC: UIViewController ,UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var indexPath : IndexPath?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return cases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases[section].caseAccounts.count

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let tableViewFrame: CGRect = tableView.frame
        let caseShow = cases[section]
//        let DoneBut: UIButton = UIButton(frame: CGRect(x: tableViewFrame.width - 40, y: 0, width: 40, height: 40))
        let DoneBut = UIButton(type: . contactAdd)
        DoneBut.frame = CGRect(x: tableViewFrame.width - 60, y: 0, width: 40, height: 40)
//        DoneBut.setTitle("+", for: .normal)
//        DoneBut.backgroundColor = UIColor.blue
        DoneBut.tag = section
        DoneBut.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
        let lbtitle:UILabel = UILabel(frame: CGRect(x: 20, y: 0, width: tableViewFrame.width - 100, height: 40))
        lbtitle.text = "案件:\(caseShow.caseName!)"
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        headerView.backgroundColor = .lightGray
        
        headerView.addSubview(DoneBut)
        headerView.addSubview(lbtitle)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let caseAccount = cases[indexPath.section].caseAccounts[indexPath.row]
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CaseCell", for: indexPath) as! CaseCell
        cell.lbAccountName.text = "記帳名稱:\(caseAccount.accountName!)"
        cell.lbAccountClass.text = "分類:\(caseAccount.accountClass!)"
        cell.lbAccountNumber.text = "金額:\(caseAccount.accountNumber!)"
        if caseAccount.accountType == "income"{
            cell.lbAccountNumber.textColor = .blue
        }else{
            cell.lbAccountNumber.textColor = .red
        }
        
        return cell
    }
    
    @objc func click(_ sender:UIButton){
        indexPath = IndexPath(row: 0, section: sender.tag)
        self.performSegue(withIdentifier: "InsertAccount", sender: sender)
    }

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "InsertAccount"{
            let tagetCase = cases[indexPath!.section]
            let nc = segue.destination as! InsertAccountNC
            let vc = nc.topViewController as! InsertAccountTVC
//            vc.tagetcase = tagetCase

        }
    }
    

}
