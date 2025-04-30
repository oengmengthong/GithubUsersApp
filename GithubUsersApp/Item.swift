//
//  Item.swift
//  GithubUsersApp
//
//  Created by Mengthong on 30/4/25.
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
