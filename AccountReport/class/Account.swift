import UIKit
import Foundation

class Account {
    var id:String?
    
    var year:Int
    var month:Int
    var day:Int
    
    var accountName:String!
    var accountNumber:Double?
    var accountClass:String?
    var accountRemark:String?
    var accountType:String!
    
    var imageUrl:String?
    var image :UIImage?
    init (accountName:String,accountType:String, year:Int , month:Int , day:Int){
        self.accountName = accountName
        self.accountType = accountType
        self.year = year
        self.month = month
        self.day = day
    }
    convenience init(){
        self.init(accountName:"",accountType:"", year:0 , month:0 , day:0)
    }
}
