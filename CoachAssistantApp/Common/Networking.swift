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
    
    private(set) var userID: String?
    
    var userGames: UserID?
        
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
                    self.userGames = decodedData
                    completion(decodedData.games?.map { $0.value })
                } catch _ as DecodingError {
                    // Handle dummy 0 as value of "games", representing empty object in Firebase's database
                    if (value as? [String: Int]) != nil {
                        self.userGames = UserID(games: [:])
                        completion([])
                        return
                    }
                    completion(nil)
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
    
    func removeGame(_ game: Game) {
        guard let user = userID else { return }
        guard let gameID = userGames?.games?.filter({ keyValuePair -> Bool in
            return keyValuePair.value == game
        }).first?.key else {
            return
        }
        db.child("users").child(user).child("games").child(gameID).setValue(nil)
    }
    
    func registerUser(useremail: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: useremail, password: password) {
            [weak self] (result, err) in
            guard err == nil, result != nil else {
                print(err as Any)
                completion(false)
                return
            }
            
            let userID = result?.user.uid ?? "sampleUserID"
            self?.db.child("users").child(userID).child("games").setValue(0) // Dummy 0 to handle empty games object
            completion(true)
        }
    }
    
    func loginUser(useremail: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: useremail, password: password) {
            [weak self] (result, err) in
            guard err == nil, let result = result else {
                print(err as Any)
                completion(false)
                return
            }
            
            self?.userID = result.user.uid
            completion(true)
        }
    }
}
