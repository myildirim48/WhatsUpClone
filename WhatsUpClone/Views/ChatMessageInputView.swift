//
//  ChatMessageInputView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 20.04.2023.
//

import SwiftUI

struct ChatMessageInputView: View {
    
    @Binding var groupDetailConfig: GroupDetailConfig
    @FocusState var isChatTextFieldFocused: Bool
    var onSendMessage: () -> Void
    
    
    var body: some View {
        HStack {
            Button {
                groupDetailConfig.showOptions = true
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
            }
            
            TextField("Enter text here..", text: $groupDetailConfig.chatText)
                .textFieldStyle(.roundedBorder)
                .focused($isChatTextFieldFocused)
            
            Button {
                if groupDetailConfig.isValid {
                    onSendMessage()
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .font(.largeTitle)
                    .rotationEffect(Angle(degrees: 44))
                    .foregroundColor(.blue)
            }.disabled(!groupDetailConfig.isValid)


        }
    }
}

struct ChatMessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageInputView(groupDetailConfig: .constant(GroupDetailConfig(chatText: "Hello World")), onSendMessage: {})
    }
}
