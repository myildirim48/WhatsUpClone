//
//  GroupDetailView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct GroupDetailView: View {
    let group: GroupModel
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var appState: AppState
    @State private var groupDetailConfig = GroupDetailConfig()
    @FocusState private var isChatFieldFocused: Bool
    
    private func sendMessage() async throws {
        guard let user = Auth.auth().currentUser else { return }
        var chatMessage = ChatMessage(text: groupDetailConfig.chatText, uuid: user.uid, displayName: user.displayName ?? "Guest", profilePhotoURL: user.photoURL == nil ? "" : user.photoURL!.absoluteString)
        
        if let selectedImage = groupDetailConfig.selectedImage{
            guard let resizedImage = selectedImage.resize(to: CGSize(width: 600, height: 600)),
                  let imageData = resizedImage.pngData() else { return }
            
            let url = try await Storage.storage().uploadData(for: UUID().uuidString, data: imageData, bucket: .attachments)
            chatMessage.attachmentPhotoURL = url.absoluteString
        }
        
        try await model.saveChatMesssageToGroup(chatText: chatMessage, group: group)
    }
    
    private func clearFields() {
        groupDetailConfig.clearfForm()
        appState.loadingState = .idle
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
        }
        .frame(maxWidth: .infinity)
        .padding()
        .confirmationDialog("Options", isPresented: $groupDetailConfig.showOptions, actions: {
            Button("Camera") {
                groupDetailConfig.sourceType = .camera
            }

            Button("Photo Library") {
                groupDetailConfig.sourceType = .photoLibrary
            }
        })
        .sheet(item: $groupDetailConfig.sourceType, content: { sourceType in
            ImagePicker(sourceType: sourceType, image: $groupDetailConfig.selectedImage)
        })
        .overlay(alignment: .center, content: {
            if let selectedImage = groupDetailConfig.selectedImage {
                PreviewImageView(selectedImage: selectedImage) {
                    withAnimation {
                        groupDetailConfig.selectedImage = nil
                    }
                }
            }
        })
        .overlay(alignment: .bottom, content: {
                ChatMessageInputView(groupDetailConfig: $groupDetailConfig, isChatTextFieldFocused: _isChatFieldFocused) {
                    Task {
                        do {
                            appState.loadingState = .loading("Sending...")
                            try await sendMessage()
                            clearFields()
                        }catch{
                            print(error.localizedDescription)
                            clearFields()
                        }
                    }
                }.padding()
            })
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
            .environmentObject(AppState())
    }
}
