//
//  AuthenticationManager.swift
//  temptation
//
//  Created by ehsanyaqoob on 31/03/2026.
//

import Foundation

import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}


class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenicatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
         return AuthDataResultModel(user:user)
    }
    
    @discardableResult
    func createUser(email: String, password: String)  async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}
