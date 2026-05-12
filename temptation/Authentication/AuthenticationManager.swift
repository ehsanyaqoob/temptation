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


enum AuthProviderOptions: String {
    case email = "password"
    case google = "google.com"
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
    
    func getProviders() throws -> [AuthProviderOptions] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOptions] = []
        for provider in providerData {
            if let option = AuthProviderOptions(rawValue: provider.providerID){
                providers.append(option)
            }
            else {
                assertionFailure("Provider not found\(provider.providerID)")
            }
        }
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}

// MARK: SIGN IN WITH EMAIL
extension AuthenticationManager {
    // for SignUp user
    @discardableResult
    func createUser(email: String, password: String)  async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // for SignIn user
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // passwor reset
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // for updating password
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
    }
    
    // for updating email
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        try await user.updateEmail(to: email)
    }
}

// MARK: SIGN IN SSO
extension AuthenticationManager {
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel{
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        
        return AuthDataResultModel(user: authDataResult.user)
    }
}
