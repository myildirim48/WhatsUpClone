//
//  ChatMessageView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import SwiftUI

enum ChatMessageDirection {
    case right
    case left
}

struct ChatMessageView: View {
    let message: ChatMessage
    let direction: ChatMessageDirection
    let color: Color
    
    @ViewBuilder
    private func profilePhotoForChatMessage(chatMessage: ChatMessage) -> some View{
        if let profilePhotoURL = chatMessage.displayProfilePhotoURL {
            AsyncImage(url: profilePhotoURL) { image in
                image.rounded(width: 34, height: 34)
            } placeholder: {
                Image(systemName: "person.crop.circle")
                    .font(.title)
            }
        }else {
            Image(systemName: "person.crop.circle")
                .font(.title)
        }
    }
    
    var body: some View {
        HStack {
            //Profile photo
            
            if direction == .left {
                profilePhotoForChatMessage(chatMessage: message)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(message.displayName)
                    .opacity(0.8)
                    .font(.caption)
                    .foregroundColor(.white)
                
                //Photourl
                
                if let attachmentPhotoURL = message.displayAttachmentPhotoURL{
                    AsyncImage(url: attachmentPhotoURL) { image in
                        image.resizable()
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .shadow(color: .black, radius: 5)
                            
                            
                    } placeholder: {
                        ProgressView("Loading...")
                    }

                }
                
                Text(message.text)
                
                Text(message.dateCreated, format: .dateTime)
                    .font(.caption)
                    .opacity(0.4)
                    .frame(maxWidth: 250, alignment: .trailing)
            }.padding()
                .background(color)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            //Profile photo
        }.listRowSeparator(.hidden)
            .overlay(alignment: direction == .left ? .bottomLeading : .bottomTrailing) {
                 Image(systemName: "arrowtriangle.down.fill")
                    .font(.largeTitle)
                    .rotationEffect(.degrees(direction == .left ? 35: -35))
                    .offset(x: direction == .left ? 30 : -30, y: 17)
                    .foregroundColor(color)
            }
        
        if direction == .right {
            profilePhotoForChatMessage(chatMessage: message)
        }
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(message: ChatMessage(documentId: "asdasd", text: "Hello everyone!!!", uuid: "123", dateCreated: Date(), displayName: "Mamiko"),direction: .left ,color: .mint)
    }
}
