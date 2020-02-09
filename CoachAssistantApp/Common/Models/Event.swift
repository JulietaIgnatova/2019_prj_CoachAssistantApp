//
//  Event.swift
//  CoachAssistantApp
//
//  Created by Dimitar Parapanov on 8.02.20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import Foundation

struct Event: Codable {
    let time: Int
    let type: String
    let playerName: String
}
