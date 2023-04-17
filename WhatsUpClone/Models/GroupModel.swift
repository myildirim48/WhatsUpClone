//
//  GroupModel.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import Foundation
import FirebaseFirestore
struct GroupModel: Codable, Identifiable{
    var documentId: String? = nil
    let subject: String
    
    var id: String {
        documentId ?? UUID().uuidString
    }
}


extension GroupModel{
    func toDictionary() -> [String:Any]{
        return ["subject":subject]
    }
    
    static func fromSnapShot(snapshot: QueryDocumentSnapshot) -> GroupModel? {
        let dictionary = snapshot.data()
        guard let subject = dictionary["subject"] as? String else {
            return nil
        }
        return GroupModel(documentId: snapshot.documentID, subject: subject)
    }
}
