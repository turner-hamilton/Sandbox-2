//
//  Messages.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 5/2/23.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}
