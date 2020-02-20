
import Foundation

class Staff {
    var id:String?
    
    var startDate:Date?
    
    var staffName:String!
    var staffJob:String?
    var staffphone:String?
    var imageUrl:String?
    var moneyType:String?
    var staffRemark:String?
    var staffpay:Double?
    
    init (staffName:String){
        self.staffName = staffName
    }
    convenience init(){
        self.init(staffName:"")
    }
}
