//
//  GroupDetailConfig.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 20.04.2023.
//

import Foundation
import SwiftUI

struct GroupDetailConfig {
    var chatText: String = ""
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var showOptions: Bool = false
    
    mutating func clearfForm(){
        chatText = ""
        selectedImage = nil
    }
    
    var isValid:Bool {
        !chatText.isEmptyOrWhiteSpace
    }
}
