
import UIKit
import CoreLocation


class GPSTextfieldVC: UIViewController ,CLLocationManagerDelegate ,UITextFieldDelegate{

    var locationManager: CLLocationManager?
    var fromLocation: CLLocation?
    var stringInfo:String?
    var completionHandler:((String) -> Void)?
    @IBOutlet weak var tfInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tfInput.becomeFirstResponder()
        if let stringInfo = stringInfo {
            tfInput.text = stringInfo
        }
        setToolbar(tfInput)
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 1
        locationManager?.startUpdatingLocation()
//        locationManager?.stopUpdatingLocation()

        // Do any additional setup after loading the view.
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
    @objc func doneButtonAction() {
        self.view.endEditing(true)
        completionHandler!(tfInput.text!)
        dismiss(animated: true, completion: nil)
    }
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geocoder = CLGeocoder()
        let newLocation = locations[0]
        if fromLocation == nil {
            fromLocation = newLocation
            
        }
        geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            let placemark = placemarks?.first
            self.tfInput.text = " \(placemark!.subAdministrativeArea!) \(placemark!.thoroughfare!)"
            self.locationManager?.stopUpdatingLocation()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
