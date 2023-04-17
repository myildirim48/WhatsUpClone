//
//  ChatMessageListView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import SwiftUI
import FirebaseAuth

struct ChatMessageListView: View {
    let chatMessages: [ChatMessage]
    private func isChatFromCurrentUser(_ chatMessage: ChatMessage) -> Bool {
        guard let currentUser = Auth.auth().currentUser else { return false}
        return currentUser.uid == chatMessage.uuid
    }
    var body: some View {
        ScrollView {
            VStack {
                ForEach(chatMessages) { message in
                    VStack {
                        if isChatFromCurrentUser(message) {
                            HStack {
                                Spacer()
                                ChatMessageView(message: message, direction: .right, color: .blue)
                            }
                        }else {
                            ChatMessageView(message: message, direction: .left, color: .gray)
                            Spacer()
                            
                        }
                    }.padding(.bottom, 15)
                    Spacer()
//                        .frame(height: 20)
                        .id(message.id)
                    
                }
            }
        }
            
    }
}

struct ChatMessageListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageListView(chatMessages: [ ])
    }
}
