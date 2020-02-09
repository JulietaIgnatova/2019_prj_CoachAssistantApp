//
//  EventType.swift
//  CoachAssistantApp
//
//  Created by Dimitar Parapanov on 9.02.20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import Foundation

enum EventType: String, CaseIterable {
    case successPass = "Successful pass"
    case failedPass = "Failed pass"
    case goodPlay = "Good play"
    case badPlay = "Bad play"
    case shotOnTarget = "Shot on target"
    case shotOffTarget = "Shot off target"
    case yellowCard = "Yellow card"
    case redCard = "Red card"
    case scoredGoal = "Score goal"
    case concededGoal = "Concede goal"
    case saveGoal = "Saved"
    case successTackle = "Successful tackle"
    case failedTackle = "Failed tackle"
    case goodKick = "Good kick"
    case badKick = "Bad kick"
    case shortPass = "Short pass"
    case longPass = "Long pass"
    case clearance = "Clearance"
    case slidingTackle = "Sliding tackle"
}
