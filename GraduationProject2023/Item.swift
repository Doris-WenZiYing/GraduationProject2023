//
//  Item.swift
//  GraduationProject2023
//
//  Created by Doris Wen on 2024/1/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
