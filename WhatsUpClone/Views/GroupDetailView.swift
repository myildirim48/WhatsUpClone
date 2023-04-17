//
//  GroupDetailView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import SwiftUI
import FirebaseAuth

struct GroupDetailView: View {
    let group: GroupModel
    @EnvironmentObject private var model: Model
    @State private var chatMessage : String = ""
    
    private func sendMessage() async throws {
        guard let user = Auth.auth().currentUser else { return }
        let chatMessage = ChatMessage(text: chatMessage, uuid: user.uid, displayName: user.displayName ?? "Guest")
        try await model.saveChatMesssageToGroup(chatText: chatMessage, group: group)
    }
    
    var body: some View {
        VStack {
            
            ScrollViewReader { proxy in
                ChatMessageListView(chatMessages: model.chatMessages)
                    .onChange(of: model.chatMessages) { value in
                        if !model.chatMessages.isEmpty {
                            let lastMessage = model.chatMessages[model.chatMessages.endIndex - 1]
                            
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
            }
            
            Spacer()
            TextField("Enter a chat message", text: $chatMessage)
            Button("Send") {
                Task {
                    do {
                        try await sendMessage()
                    }catch {
                        print(error.localizedDescription)
                    }
                    
                }
              
            }.buttonStyle(.borderless)
        }.padding()
            .onDisappear{
                model.detachFirebaseListener()
            }
            .onAppear {
                model.listenForChatMesasges(in: group)
            }
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: GroupModel(subject: "Movies"))
            .environmentObject(Model())
    }
}
