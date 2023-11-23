//  LoginView.swift
//  PDM
//
//  Created by MacBook Pro on 13/11/2023.
//

import SwiftUI

struct ErrorData: Codable {
    var message: String
}

struct LoggedInUser: Codable {
    var token: String
    var refreshsecretkey: String?
    var message: String
    
    enum CodingKeys: CodingKey {
        case token
        case refreshsecretkey
        case message
    }
}

struct UserProfile: Codable {
    var name: String
    var email: String
}

struct User: Codable {
    var name: String?
    var email: String?
    var password: String?
    var age: Int?
    
    enum CodingKeys: CodingKey {
        case name
        case email
        case password
        case age
    }
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var userProfile: UserProfile?
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack {
                Image("logo.png")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)

                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    InputView(text: $password, title: "Password", placeholder: "Enter your Password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Button(action: {
                    Task {
                        await loginUser()
                    }
                }) {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemGreen))
                .cornerRadius(10)
                .padding()

                NavigationLink(
                    destination: ProfileView(userProfile: userProfile ?? UserProfile(name: "", email: "")),
                    isActive: $isLoggedIn
                ) {
                    EmptyView()
                }
                .hidden()

                NavigationLink(destination: FPasswordView().navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 3) {
                        Text("Did you forget your Password?")
                        Text("Remember it")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                .foregroundColor(.black)

                Spacer()

                NavigationLink(destination: RegistrationView().navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                .foregroundColor(.black)
            }
            .background(Color(UIColor(red: 0.92, green: 0.94, blue: 0.89, alpha: 1.0)))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func loginUser() async {
        do {
            let user = User(name: nil, email: email, password: password, age: 0)
            let url = URL(string: "http://localhost:3000/api/login")!

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let encodedData = try JSONEncoder().encode(user)
            urlRequest.httpBody = encodedData

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let loggedInUser = try JSONDecoder().decode(LoggedInUser.self, from: data)
                print(loggedInUser)

                userProfile = UserProfile(name: user.name ?? "", email: email)
                isLoggedIn = true
            } else {
                let errorData = try JSONDecoder().decode(ErrorData.self, from: data)
                print("Error: \(errorData.message)")
                showAlert = true
                alertMessage = "Login failed. \(errorData.message)"
            }
        } catch {
            print("Error: \(error)")
            showAlert = true
            alertMessage = "An error occurred. Please try again."
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
