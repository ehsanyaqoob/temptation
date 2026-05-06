//
//  SettingsView.swift
//  temptation
//
//  Created by ehsanyaqoob on 01/04/2026.
//

import SwiftUI
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    func resetPssword() async throws {
        let authUser =  try AuthenticationManager.shared.getAuthenicatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updatePassword() async throws {
        let password = "123456"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func updateEmail() async throws {
        let email = "hello3@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
}
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button("Sign Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
           
            emailSections
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}


extension SettingsView {
    private var emailSections: some View {
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPssword()
                        print("password reset!...")
                        //showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }

            Button("Update Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("password updated....")
                    } catch {
                        print(error)
                    }
                }
            }

            Button("Update Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("email updated....")
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
}
