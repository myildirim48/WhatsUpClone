//
//  Storage+Ext.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 19.04.2023.
//

import Foundation
import FirebaseStorage

enum FireBaseStorageBuckets: String {
case photos, attachments
}

extension Storage{
    
    func uploadData(for key: String, data: Data, bucket: FireBaseStorageBuckets) async throws -> URL {
        let storageRef = Storage.storage().reference()
        let photosRef = storageRef.child("\(bucket.rawValue)\(key).png")
        
        let _ = try await photosRef.putDataAsync(data)
        let downloadUrl = try await photosRef.downloadURL()
        return downloadUrl
    }
}
