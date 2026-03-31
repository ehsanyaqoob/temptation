//
//  SigninEmailView.swift
//  temptation
//
//  Created by ehsanyaqoob on 31/03/2026.
//

import SwiftUI
import Combine

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password founc.")
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password:password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error \(error)")
            }
        }
    }
}


struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    
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
                viewModel.signIn()
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
        SignInEmailView()
    }
}
