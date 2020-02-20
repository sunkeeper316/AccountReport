
import Foundation

var incomes = ["頭期","尾款","紅利"]
var outlays = ["薪資","材料","廠商花費","員工獎金"]
var caseClasses = ["木工案件"]
var cases = [Case]()
var userCount = 0
var caseCount = 0

var userId = "1"
var isnofirst = true

func loadfirst(){
    let userDefaults = UserDefaults.standard
    isnofirst = userDefaults.bool(forKey: "userisnofirst")
}
func savefirst(){
    let userDefaults = UserDefaults.standard
    let userisnofirst = isnofirst
    userDefaults.set(userisnofirst, forKey: "userisnofirst")
}
