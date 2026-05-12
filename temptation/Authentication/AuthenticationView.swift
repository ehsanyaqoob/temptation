//
//  AuthenticationView.swift
//  temptation
//
//  Created by ehsanyaqoob on 31/03/2026.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Combine
import FirebaseAuth

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignGoogleHelper()
        let tokens = try await helper.signIn()
        
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
}
    struct AuthenticationView: View {
        @StateObject private var vm = AuthenticationViewModel()
        @Binding var showSignInView: Bool
        
        var body: some View {
            VStack {
                
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign With Email")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10.0)
                }
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await vm.signInGoogle()
                            // Dismiss sign-in view on success
                            showSignInView = false
                        } catch {
                            // TODO: present a user-facing error if desired
                            print("Google sign-in failed: \(error)")
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Sign In")
        }
    }
    

    #Preview {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }

