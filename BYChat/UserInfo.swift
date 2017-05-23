import Foundation
class UserInfo: NSObject {
    var username: String = ""
    var avatar: String = ""
    
    init(name: String, logo: String){
        self.username = name
        self.avatar = logo
    }
}
