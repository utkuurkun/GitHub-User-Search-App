//
//  Item.swift
//  GitHubUserSearchApp
//
//  Created by Utku Urkun on 15.11.2024.
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
