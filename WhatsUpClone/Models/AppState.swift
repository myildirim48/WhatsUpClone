//
//  AppState.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 16.04.2023.
//

import Foundation
enum Route: Hashable{
    case main
    case login
    case signUp
}
class AppState: ObservableObject {
    @Published var routes: [Route] = []
}
