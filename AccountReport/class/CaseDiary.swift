
import Foundation

class CaseDiary {
    var id:String?
    var date:Date!
    var content:String?
    
    init (date:Date){
        self.date = date
    }
    convenience init(){
        self.init(date:Date())
    }
}

