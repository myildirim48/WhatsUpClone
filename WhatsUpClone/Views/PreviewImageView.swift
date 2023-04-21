//
//  PreviewImageView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 21.04.2023.
//

import SwiftUI

struct PreviewImageView: View {
    
    let selectedImage: UIImage
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(alignment: .top) {
                    Button {
                        onCancel()
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .font(.largeTitle)
                            .offset(x: -150, y: 20)
                            .foregroundColor(.white)
                            
                    }

                }
        }
    }
}

struct PreviewImageView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewImageView(selectedImage: UIImage(named: "sample")!, onCancel: {})
    }
}
