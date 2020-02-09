//
//  Networking.swift
//  CoachAssistantApp
//
//  Created by Yalishanda on 8.02.20.
//  Copyright © 2020 Swift FMI. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class Networking {
    private lazy var db: DatabaseReference = Database.database().reference()
    
    private init() {}
    static let shared = Networking()
    
    func fetchGames(for userID: String, completion: @escaping ([Game]?) -> Void) {
        db.child("users").child(userID).observeSingleEvent(
            of: .value,
            with: { snapshot in
                guard let value = snapshot.value else { return }
                do {
                    let decodedData = try FirebaseDecoder().decode([String : [Game]].self, from: value)
                    completion(decodedData["games"] ?? [])
                } catch let error {
                    print(error)
                    completion(nil)
                }
            }) { error in
                print(error)
                completion(nil)
            }
        
    }
    
    
}
