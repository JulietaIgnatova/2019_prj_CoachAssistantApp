//
//  Game.swift
//  CoachAssistantApp
//
//  Created by Dimitar Parapanov on 8.02.20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import Foundation

struct Game: Codable, Equatable {
    let players: [String]
    let events: [Event]
    let duration: Int
    let name: String
}
