//
//  AddNewGroupView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 16.04.2023.
//

import SwiftUI

struct AddNewGroupView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: Model
    @State private var groupSubject: String = ""
    
    private var isFormValid: Bool {
        !groupSubject.isEmptyOrWhiteSpace
    }
    
    private func saveGroup() {
        let group = GroupModel(subject: groupSubject)
        model.saveGroup(group: group) { error in
            if let error {
                print(error.localizedDescription)
            }
            dismiss()
        }
        
    }
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Group Subject", text: $groupSubject)
                }
                Spacer()
            }.padding()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("New Group")
                            .bold()
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel", action: {
                            dismiss()
                        })
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Create", action: {
                            saveGroup()
                        }).disabled(!isFormValid)
                    }
                }.padding()
        }
 
    }
}

struct AddNewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddNewGroupView()
                .environmentObject(Model())
        }
    }
}
