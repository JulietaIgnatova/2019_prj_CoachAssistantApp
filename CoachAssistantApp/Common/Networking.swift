//
//  Networking.swift
//  CoachAssistantApp
//
//  Created by Dimitar Parapanov on 8.02.20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class Networking {
    private lazy var db: DatabaseReference = Database.database().reference()
    
    private init() {}
    static let shared = Networking()
    
    private(set) var userID: String? = "sampleUserID"
        
    func fetchGames(completion: @escaping ([Game]?) -> Void) {
        guard let user = userID else {
            completion(nil)
            return
        }
        db.child("users").child(user).observeSingleEvent(
            of: .value,
            with: { snapshot in
                guard let value = snapshot.value else {
                    completion(nil)
                    return
                }
                do {
                    let decodedData = try FirebaseDecoder().decode(UserID.self, from: value)
                    completion(Array(decodedData.games.values))
                } catch let error {
                    print(error)
                    completion(nil)
                }
            }, withCancel: { error in
                print(error)
                completion(nil)
            })
    }
    
    func addGame(_ game: Game) {
        guard let user = userID else { return }
        do {
            let encodedGame = try FirebaseEncoder().encode(game)
            db.child("users").child(user).child("games").childByAutoId().setValue(encodedGame)
        } catch let error {
            print(error)
        }
    }
}
