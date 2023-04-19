//
//  UIImagePickerControllerSourceType+Ext.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import Foundation
import SwiftUI
extension UIImagePickerController.SourceType: Identifiable{
    public var id:Int {
        switch self {
        case .photoLibrary:
            return 2
        case .camera:
            return 1
        case .savedPhotosAlbum:
            return 3
        default:
            return 4
        }
    }
}
