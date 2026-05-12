//
//  SignInGoogleHelper.swift
//  temptation
//
//  Created by ehsanyaqoob on 12/05/2026.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

final class SignGoogleHelper {
    func signIn() async throws -> GoogleSignInResultModel {
        // Use the updated utility to find the presenting VC
        guard let topVC = Utilities.topViewController() else {
            throw URLError(.cannotOpenFile)
        }
        // 1. Google Sign In
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        // 2. Firebase Authentication
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        return tokens
        
        //        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        //        let _ = try await Auth.auth().signIn(with: credential)
    }
}
