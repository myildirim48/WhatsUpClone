//
//  Image+Ext.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import Foundation
import SwiftUI
extension Image {
    func rounded(width: CGFloat = 100, height: CGFloat = 100)-> some View  {
        return self.resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
