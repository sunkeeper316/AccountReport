

import UIKit

class InsertAccountNC: UINavigationController {

    var tagetcase:Case!
    override func viewDidLoad() {
        super.viewDidLoad()

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "InsertAccountTVC") as! InsertAccountTVC
//        vc.tagetcase = tagetcase
//        print("case\(tagetcase)")

        // Do any additional setup after loading the view.
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! InsertAccountTVC
//        vc.tagetcase = tagetcase
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
