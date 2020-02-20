

import UIKit

class IncomeTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return incomes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let income = incomes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeCell", for: indexPath) as! IncomeCell
        cell.lbincome.text = income

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let action = UIAlertAction(title: "ok", style: .default) { (action) in
                incomes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            let alert = UIAlertController(title: nil, message: "確定要刪除嗎？", preferredStyle: .alert)
            alert.addAction(cancel)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            // Delete the row from the data source
            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VC = segue.destination as! SetinoutVC
        VC.keyword = "income"
        VC.tabelView = tableView
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
