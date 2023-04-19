//
//  Model.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 16.04.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class Model: ObservableObject {
    
    @Published var groups: [GroupModel] = []
    @Published var chatMessages: [ChatMessage] = []
    
    var firestoreListener: ListenerRegistration?
    
    
    private func updateUserInfoForAllMessages(uid: String, updateInfo: [AnyHashable: Any]) async throws {
        let db = Firestore.firestore()
        let groupDocument = try await db.collection("groups").getDocuments().documents
        
        for groupDoc in groupDocument {
            let messages = try await groupDoc.reference.collection("messages")
                .whereField("uid", isEqualTo: uid)
                .getDocuments().documents
            
            for message in messages {
                try await message.reference.updateData(updateInfo)
            }
        }
    }
    
     func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
         try await updateUserInfoForAllMessages(uid: user.uid, updateInfo: ["displayName": user.displayName ?? "Guest"])
    }
    
    func detachFirebaseListener() {
        self.firestoreListener?.remove()
    }
    
    func updatePhotoURL(for user: User, photoUrl: URL) async throws{
        let request = user.createProfileChangeRequest()
        request.photoURL = photoUrl
        try await request.commitChanges()
        try await updateUserInfoForAllMessages(uid: user.uid, updateInfo: ["profilePhotoURL": photoUrl.absoluteString])

    }
    
    func listenForChatMesasges(in group: GroupModel) {
        chatMessages.removeAll()
        let db = Firestore.firestore()
        guard let documentId = group.documentId else { return }
        self.firestoreListener = db.collection("groups")
            .document(documentId)
            .collection("messages")
            .order(by: "dateCreated",descending: false)
            .addSnapshotListener({ [weak self] snapshot, error in
                guard let snapshot else {
                    print(error!.localizedDescription)
                    return
                }
                
                snapshot.documentChanges.forEach { diffrence in
                    if diffrence.type == .added {
                        let chatMessage = ChatMessage.fromSnapShot(snapshot: diffrence.document)
                        if let chatMessage {
                            let exists = self?.chatMessages.contains { cm in
                                cm.documentId == chatMessage.documentId
                            }
                            if !exists! {
                                self?.chatMessages.append(chatMessage)
                            }
                        }
                    }
                }
            })
    }
    
    func populateGroups() async throws {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("groups")
            .getDocuments()
        
        groups = snapshot.documents.compactMap { snapshot in
            GroupModel.fromSnapShot(snapshot:snapshot)
        }
    }
    
  
    func saveChatMesssageToGroup(chatText: ChatMessage, group: GroupModel) async throws {
                let db = Firestore.firestore()
                guard let documentID = group.documentId else { return }
       let _ = try await db.collection("groups")
            .document(documentID)
            .collection("messages")
            .addDocument(data: chatText.toDictionary())
    }
    
    func saveGroup(group: GroupModel, completion: @escaping(Error?) -> Void) {
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef =  db.collection("groups")
            .addDocument(data: group.toDictionary()) { [weak self] error in
                guard let self else { return }
                if error != nil {
                    completion(error)
                }else {
                    if let docRef {
                        var newGroup = group
                        newGroup.documentId = docRef.documentID
                        self.groups.append(newGroup)
                        completion(nil)
                    }else {
                        completion(nil)
                    }
                    
                }
            }
    }
}
