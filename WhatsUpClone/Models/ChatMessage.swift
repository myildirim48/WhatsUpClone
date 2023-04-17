//
//  ChatMessage.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import Foundation
import FirebaseFirestore

struct ChatMessage: Codable,Identifiable,Equatable {
    
    var documentId: String?
    let text: String
    let uuid: String
    var dateCreated = Date()
    let displayName: String
    
    var id: String {
        documentId ?? UUID().uuidString
    }
}

extension ChatMessage {
    func toDictionary() -> [String: Any]  {
        return [
            "text" : text,
            "uid" : uuid,
            "dateCreated" : dateCreated,
            "displayName" : displayName
        ]
    }
    
   static func fromSnapShot(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let dict = snapshot.data()
        guard let text = dict["text"] as? String,
              let uid = dict["uid"] as? String,
              let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue(),
              let displayName = dict["displayName"] as? String else {
            return nil
        }
        
        return ChatMessage(documentId: snapshot.documentID, text: text, uuid: uid, dateCreated: dateCreated, displayName: displayName)
                
    }
}
