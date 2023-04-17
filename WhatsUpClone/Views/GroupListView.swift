//
//  GroupListView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import SwiftUI

struct GroupListView: View {
    let groups: [GroupModel]
    var body: some View {
        List(groups) { group in
            NavigationLink {
                GroupDetailView(group: group)
            } label: {
                HStack {
                    Image(systemName: "person.2")
                    Text(group.subject)
                }
            }

        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView(groups: [])
    }
}
