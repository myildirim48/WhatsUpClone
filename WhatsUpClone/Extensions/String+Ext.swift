//
//  String+Ext.swift
//  WhatsUpClone
//
//  Created by YILDIRIM on 16.04.2023.
//

import Foundation
extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
