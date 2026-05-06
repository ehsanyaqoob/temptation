//
//  SigninEmailView.swift
//  temptation
//
//  Created by ehsanyaqoob on 31/03/2026.
//

import SwiftUI
import Combine


enum ValidationError: Error {
    case emptyFields
}

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp()  async throws {
        guard !email.isEmpty, !password.isEmpty else {
           // throw ValidationError.emptyFields
            print("no email or passowrd found ...")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password:password)
    }
    
    func signIn()  async throws {
        guard !email.isEmpty, !password.isEmpty else {
            // throw ValidationError.emptyFields
             print("no email or passowrd found ...")
             return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password:password)
    }
}


struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack (spacing: 16){
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .textContentType(.password)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return 
                    } catch {
                        print(error)
                    }

                }
                
                
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10.0)
            }
            Spacer()
            
            
        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
