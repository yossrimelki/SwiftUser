//
//  FPasswordView.swift
//  PDM
//
//  Created by MacBook Pro on 16/11/2023.
//

import SwiftUI

struct ForgetPasswordRequest: Codable {
    var email: String
    
    enum CodingKeys: CodingKey {
        case email
    }
}

struct FPasswordView: View {
    @State private var email = ""
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
                    .padding()
                
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button(action: {
                    Task {
                        await forgetPassword()
                        
                        
                    }
                }) {
                    HStack {
                        Text("Remember It!")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemGreen).cornerRadius(10))
                .padding()
                
                NavigationLink(destination: ResetPView().navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 3) {
                        Text("Reset Password")
                        Text("RESET")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                .foregroundColor(.black)
                .padding()
                
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                    HStack(spacing: 3) {
                        Text("Login to your account?")
                        Text("Sign In")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                .foregroundColor(.black)
                .padding()
                
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
            .padding()
            .background(Color(UIColor(red: 0.92, green: 0.94, blue: 0.89, alpha: 1.0)))
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func forgetPassword() async {
        do {
            let request = ForgetPasswordRequest(email: email)
            let url = URL(string: "http://localhost:3000/api/forget-password")!
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encodedData = try JSONEncoder().encode(request)
            urlRequest.httpBody = encodedData
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Check Your Mail!")
            } else {
                let errorData = try JSONDecoder().decode(ErrorData.self, from: data)
                print("Error: \(errorData.message)")
                showAlert = true
                alertMessage = "Email doesn't Exist! \(errorData.message)"
            }
        } catch {
            print("Error: \(error)")
            showAlert = true
            alertMessage = "An error occurred. Please try again."
        }
    }
}
#if DEBUG
struct FPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        FPasswordView()
    }
}
#endif
