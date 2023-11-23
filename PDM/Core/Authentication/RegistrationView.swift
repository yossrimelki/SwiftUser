//
//  RegistrationView.swift
//  PDM
//
//  Created by MacBook Pro on 14/11/2023.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var age = "0"
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            Image("logo.png")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)

            VStack(spacing: 24) {
                InputView(text: $fullName, title: "Full Name", placeholder: "e.g., YossriMelki")
                    .autocapitalization(.none)
                InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                    .autocapitalization(.none)
                InputView(text: $age, title: "Age", placeholder: "Enter a number, e.g., 24")
                    .autocapitalization(.none)
                InputView(text: $password, title: "Password", placeholder: "Enter your Password", isSecureField: true)

                InputView(text: $confirmPassword, title: "Confirm your Password", placeholder: "Confirm your Password", isSecureField: true)
            }
            .padding(.horizontal)
            .padding(.top, 12)

            Button {
                Task {
                    await registerUser()
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemGreen)
                .cornerRadius(10)
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            Spacer()

            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
            .foregroundColor(.black)
        }
        .background(Color(UIColor(red: 0.92, green: 0.94, blue: 0.89, alpha: 1.0)))
    }

    private func registerUser() async {
        do {
            let user = User(name:fullName,email: email, password: password,age: Int(age) ?? 0)
            let url = URL(string: "http://localhost:3000/api/register")!

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let encodedData = try JSONEncoder().encode(user)
            urlRequest.httpBody = encodedData

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Registration successful, you can handle it as needed (e.g., show a success message)
                print("Registration successful!")
            } else {
                let errorData = try JSONDecoder().decode(ErrorData.self, from: data)
                print("Error: \(errorData.message)")
                showAlert = true
                alertMessage = "Registration failed. \(errorData.message)"
            }
        } catch {
            print("Error: \(error)")
            showAlert = true
            alertMessage = "An error occurred. Please try again."
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
