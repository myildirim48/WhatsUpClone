//
//  SettingsView.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 17.04.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct SettingsConfig {
    var showPhotoOptions: Bool = false
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var displayName: String = ""
}

struct SettingsView: View {
    
    @State private var settingsConfig = SettingsConfig()
    @FocusState var isEditing: Bool
    @EnvironmentObject private var model: Model
    @State private var currentPhoroUrl: URL? = Auth.auth().currentUser!.photoURL
    
    var displayName: String {
        guard let user = Auth.auth().currentUser else { return "Guest" }
        return user.displayName ?? "Guest"
    }
    
    var body: some View {
        VStack {
            
            AsyncImage(url: currentPhoroUrl) { image in
                image.rounded()
            } placeholder: {
                Image(systemName: "person.crop.circle.fill")
                    .rounded()
            }
                .onTapGesture {
                    settingsConfig.showPhotoOptions = true
                }.confirmationDialog("Select", isPresented: $settingsConfig.showPhotoOptions) {
                    Button("Camera") {
                        settingsConfig.sourceType = .camera
                    }
                    
                    Button("Photo Library") {
                        settingsConfig.sourceType = .photoLibrary
                    }
                }
            TextField(settingsConfig.displayName, text: $settingsConfig.displayName)
                .textFieldStyle(.roundedBorder)
                .focused($isEditing)
                .textInputAutocapitalization(.never)
            Spacer()
            
            Button("Sign Out") {
                
            }
        }.sheet(item: $settingsConfig.sourceType, content: { sourceType in
            ImagePicker(sourceType: sourceType, image: $settingsConfig.selectedImage)
        })
        .onChange(of: settingsConfig.selectedImage, perform: { image in
            guard let image ,
                    let resizedImage = image.resize(to: CGSize(width: 100, height: 100)),
                  let imageData = resizedImage.pngData()
            else { return }
            
            Task {
                guard let currentUser = Auth.auth().currentUser else { return }
                let fileName = "\(currentUser.uid).png"
                do {
                    let url = try await Storage.storage().uploadData(for: fileName, data: imageData, bucket: .photos)
                    try await model.updatePhotoURL(for: currentUser, photoUrl: url)
                    currentPhoroUrl = url
                }catch {
                    print(error)
                }
                  
            }
            
        })
        .padding()
            .onAppear{
                settingsConfig.displayName = displayName
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let currenUser = Auth.auth().currentUser else { return }
                        
                        Task {
                            do {
                                try await model.updateDisplayName(for: currenUser, displayName: settingsConfig.displayName)
                            }catch {
                                print(error)
                            }
                            
                        }
                        
                    }
                }
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Model())
    }
}
