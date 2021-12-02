import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var title: String?
    var memo: String?
    var date: Date?
    var isArchived: Bool? = false

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let postDic = document.data()
        self.title = postDic["title"] as? String
        self.memo = postDic["memo"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        self.isArchived = postDic["isArchived"] as? Bool
    }
}
