

import UIKit
import Firebase
import FBSDKLoginKit

class LoginTVC: UITableViewController {
    
    @IBOutlet weak var btFBLogin: FBLoginButton!
    var fbLongin : LoginManager?
    
    
    @IBOutlet weak var tfId: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let firebaseAuth = Auth.auth()
        fbLongin = LoginManager()
        
//        do {
//          try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//          print ("Error signing out: %@", signOutError)
//        }
        print()
        print("firebaseAuth.currentUser\(firebaseAuth.currentUser?.uid ?? "")")
        btFBLogin.setTitle("FB Login", for: .normal)
        if AccessToken.current != nil {
            print("tokenString: \(AccessToken.current!.tokenString)")
            AccessToken.current = nil
            
            fbLongin?.logOut()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//
//        print("LoginManager.self")
////        fetchProfile()
//    }
    
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//
//    }
    func fetchProfile(){
        print("attempt to fetch profile......")
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        
        GraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: {
            connection, result, error -> Void in
            
            
            if error != nil {
                print("登入失敗")
                print("longinerror =\(error)")
                return
            } else {
                
                if let resultNew = result as? [String:Any]{
                    
                    print("成功登入")
                    
                    let email = resultNew["email"]  as! String
                    print(email)
                    
                    let firstName = resultNew["first_name"] as! String
                    print(firstName)
                    
                    let lastName = resultNew["last_name"] as! String
                    print(lastName)
                    
                    if let picture = resultNew["picture"] as? NSDictionary,
                        let data = picture["data"] as? NSDictionary,
                        let url = data["url"] as? String {
                        print(url) //臉書大頭貼的url, 再放入imageView內秀出來
                    }
                }
                
                
            }
        })
    }
    @IBAction func clickFBLogin(_ sender: FBButton) {
        print("FB")
        fbLongin = LoginManager()
        fbLongin?.logIn(permissions: ["public_profile", "email"], from: self, handler: { (result, error) in
            if error == nil {
                if result != nil && !result!.isCancelled {
                    print("Login")
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    Auth.auth().signIn(with: credential) { (user, error) in
                        print("signIn")
//                        user?.user.uid
                        print(user?.user.uid.description)
                    }
                }
            }else{
                print(error!.localizedDescription)
            }
        })
    }
    @IBAction func clickLogin(_ sender: Any) {
        checkAccount()
    }
    
    @IBAction func clickDirect(_ sender: Any) {
        getUserCount()
        isnofirst = true
        savefirst()
        dismiss(animated: true, completion: nil)
        
    }
    // MARK: - Table view data source
    @IBAction func clickCreate(_ sender: UIButton) {
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
        userCount += 1
        let doc = db.collection("UserAccount").document("\(userCount)")
        doc.setData(["id" : userCount , "userId" : userCount])
        db.collection("UserAccount").document("user").setData(["UserAccount" : userCount])
        
    }
    func checkAccount(){
        let db = Firestore.firestore()
        db.collection("UserAccount").whereField("userId", isEqualTo: "\(tfId.text!)").getDocuments { (docSnapshots, error) in
            if let docSnapshots = docSnapshots?.documents{
                for docSnapshot in docSnapshots {
                    
                    
                }
            }else{
                print("error")
            }
        }
        //        db.collection("UserAccount").whereField("Account", arrayContains: "\(tfId.text!)").getDocuments { (docSnapshots, error) in
        //            if let docSnapshots = docSnapshots?.documents{
        //                for docSnapshot in docSnapshots {
        //
        //                    print(docSnapshot.data())
        //                }
        //            }else{
        //                print("error")
        //            }
        //
        //        }
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
}
