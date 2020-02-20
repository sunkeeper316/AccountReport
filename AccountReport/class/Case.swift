import Foundation

class Case {
    var id:String?
    
    var date :Date
    var caseClass:String!
    var caseName:String?
    var casePosition:String?
    
    var caseStaff = [Staff]()
    var caseDiarys = [CaseDiary]()
    var caseAccounts = [Account]()
    
    var caseDiaryCount:Int?
    var caseIncomes:Int?
    var caseOutlays:Int?
    var caseStaffs:Int?
    
    var imageUrl1:String?
    var imageUrl2:String?
    var imageUrl3:String?
    
    var isMark:Bool
    
    init (caseClass:String ,date:Date){
        self.caseClass = caseClass
        self.date = date
        self.isMark = false
    }
    convenience init(){
        self.init(caseClass:"",date:Date())
    }

}

