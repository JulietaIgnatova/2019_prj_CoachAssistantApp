//
//  Networking.swift
//  CoachAssistantApp
//
//  Created by Yalishanda on 8.02.20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import Foundation
import Firebase

class Networking {
    private lazy var ref: DatabaseReference = Database.database().reference()
    
    private init() {}
    static let shared = Networking()
    
    func fetchGames(for userID: String) -> [Game] {
        // TODO
        return []
    }
    
    
}
