
import Foundation

var str = "Hello, playground"

class A {
    func printy(name: String) -> String {
        return ("\(name)")
    }
}
class B : A {
    override init() {
        super.init()
    }
    
    override func printy(name: String) -> String {
        return "Hi, my Name is \(name)"
    }
}

var b = B()
b.printy("Jan")
println("Jan")

var a = b as A
b.printy("Jo")

var a1 = A()

//var aa = a1 as! B
//aa?.printy("txt")

[[String?]](count:11, repeatedValue: [nil])

var y = [[Int?]](count: 12, repeatedValue: [])

y[0].append(2)
y[0].append(3)
y[0][0]!
y[0]


var x = [Int]()
x.append(1)
x.append(2)
//var yyy : Int? = 0
//if let x = yyy && (yyy > 0) {
//    let iddqd = 0
//}

let array = [1,2,3,4,5,6,7]
array[0...1]

var array2 = [[1,2],[],[],[3,4],[5,6,7]]
var array3 = array2[0...3]
for x in array3 {
    var y = x
    y.append(2)
    //y
}

var mydict = [Int: [String]]()
mydict[0] = ["Ja"]
mydict[1] = ["Nein"]
mydict.count

let userCalendar = NSCalendar.currentCalendar()

var date = NSDateComponents()
date.day = 1
date.month = 1
date.year
let valentinesDay = userCalendar.dateFromComponents(date)!

date.year






