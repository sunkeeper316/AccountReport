

import UIKit

class NumberVC: UIViewController {

    var completionHandler:((String) -> Void)?
    var numberOnScreen:Double = 0
    var previousNumber:Double = 0
    var performingMath = false
    var clearNumber = false
    var infostring:String!
    var sign :String = ""
    
    
    @IBOutlet weak var lbNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if infostring != "" || infostring != nil{
            lbNumber.text = infostring
        }
        
    }
    
    @IBAction func clickBack(_ sender: Any) {
//    var check = lbNumber.text!
        if lbNumber.text!.count > 1 {
            lbNumber.text!.remove(at: lbNumber.text!.index(before: lbNumber.text!.endIndex))
            numberOnScreen = (Double(lbNumber.text!)!)
            
        }else{
            lbNumber.text! = "0"
            numberOnScreen = 0
        }
       
    }
    @IBAction func clickClear(_ sender: Any) {
        lbNumber.text = "0"
        numberOnScreen = 0
        previousNumber = 0
        sign = ""
        performingMath = false
        
    }
    @IBAction func clickDivision(_ sender: Any) {
        previousNumber = numberOnScreen
        sign = "/"
        performingMath = true
        clearNumber = true
    }
    @IBAction func clickMultiplication(_ sender: Any) {
        previousNumber = numberOnScreen
        sign = "*"
        performingMath = true
        clearNumber = true
    }
    @IBAction func clickSubtraction(_ sender: Any) {
        previousNumber = numberOnScreen
        sign = "-"
        performingMath = true
        clearNumber = true
    }
    @IBAction func clickAdd(_ sender: Any) {
        previousNumber = numberOnScreen
        sign = "+"
        performingMath = true
        clearNumber = true
    }
    @IBAction func clickNine(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "9"
        numberOnScreen = (Double(lbNumber.text!)!)
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickEight(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "8"
        numberOnScreen = (Double(lbNumber.text!)!)
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickSeven(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "7"
        numberOnScreen = (Double(lbNumber.text!)!)
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickSix(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "6"
        numberOnScreen = (Double(lbNumber.text!)!)
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickFive(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "5"
        numberOnScreen = (Double(lbNumber.text!)!)
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickFour(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "4"
        numberOnScreen = (Double(lbNumber.text!)!)
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickThree(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "3"
        numberOnScreen = (Double(lbNumber.text!)!)
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickTwo(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "2"
        numberOnScreen = (Double(lbNumber.text!)!)
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickOne(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "1"
        numberOnScreen = (Double(lbNumber.text!)!)
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickZero(_ sender: Any) {
        if clearNumber {
            lbNumber.text = ""
            clearNumber = false
        }
        lbNumber.text! = lbNumber.text! + "0"
        numberOnScreen = (Double(lbNumber.text!)!)
        if lbNumber.text!.contains("."){
            return
        }
        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickDot(_ sender: Any) {
        let check = lbNumber.text!
        if check.contains("."){
            return
        }
        lbNumber.text! = lbNumber.text! + "."
        
//        makeOKNumberString(from: (Double(lbNumber.text!))!)
    }
    @IBAction func clickEqual(_ sender: Any) {
        if performingMath {
            if sign == "+"{
                numberOnScreen = previousNumber + numberOnScreen
                makeOKNumberString(from: numberOnScreen)
            }else if sign == "-"{
                numberOnScreen = previousNumber - numberOnScreen
                makeOKNumberString(from: numberOnScreen)
            }else if sign == "*"{
                numberOnScreen = previousNumber * numberOnScreen
                makeOKNumberString(from: numberOnScreen)
            }else if sign == "/"{
                numberOnScreen = previousNumber / numberOnScreen
                makeOKNumberString(from: numberOnScreen)
            }
            performingMath = false
        }
        
    }
    @IBAction func clickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func clickOK(_ sender: Any) {
        completionHandler!("\(lbNumber.text!)")
        dismiss(animated: true, completion: nil)
    }
    func makeOKNumberString(from number:Double){
        if floor(number) == number{
            lbNumber.text = "\(Int(number))"
        }else{
            lbNumber.text = "\(number)"
        }
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
