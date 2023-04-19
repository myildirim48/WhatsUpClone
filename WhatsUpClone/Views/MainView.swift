//
//  MainView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 16.04.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            GroupListContainerView()
                .tabItem {
                    Label("Chats", systemImage: "message.fill")
                }
            
            Text("Settings")
            SettingsView()
                .tabItem {
                    Label("Settingd", systemImage: "gear")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
