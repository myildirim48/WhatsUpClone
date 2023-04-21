//
//  ErrorWrapper.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 21.04.2023.
//

import Foundation
struct ErrorWrapper:Identifiable {
    let id = UUID()
    let error: Error
    var guidance: String = ""
}
