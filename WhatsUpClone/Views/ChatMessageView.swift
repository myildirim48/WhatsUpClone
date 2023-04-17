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
    var body: some View {
        HStack {
            //Profile photo
            VStack(alignment: .leading, spacing: 5) {
                Text(message.displayName)
                    .opacity(0.8)
                    .font(.caption)
                    .foregroundColor(.white)
                
                //Photourl
                
                Text(message.text)
                
                Text(message.dateCreated, format: .dateTime)
                    .font(.caption)
                    .opacity(0.4)
                    .frame(maxWidth: 200,alignment: .trailing)
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
    }
}

struct ChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessageView(message: ChatMessage(documentId: "asdasd", text: "Hello everyone!!!", uuid: "123", dateCreated: Date(), displayName: "Mamiko"),direction: .left ,color: .mint)
    }
}
