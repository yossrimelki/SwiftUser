import SwiftUI

struct ResetPasswordRequest: Codable {
    var password: String
    var token: String
}

struct ResetPView: View {
    // MARK: - Properties
    @State private var token = ""
    @State private var password = ""
    @State private var Cpassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                // Logo
                logoImage

                // Input fields
                inputFields

                // Reset password button
                resetPasswordButton

                // Navigation links
                additionalNavigationLinks
            }
            .background(Color(UIColor(red: 0.92, green: 0.94, blue: 0.89, alpha: 1.0)))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Subviews
    private var logoImage: some View {
        Image("logo.png")
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 120)
            .padding(.vertical, 32)
    }

    private var inputFields: some View {
        VStack(spacing: 24) {
            InputView(text: $token, title: "Token", placeholder: "Enter your Token")
                .autocapitalization(.none)
            InputView(text: $password, title: "Password", placeholder: "Enter your Password", isSecureField: true)
                .autocapitalization(.none)
            InputView(text: $Cpassword, title: "Confirm Password", placeholder: "Confirm your Password", isSecureField: true)
                .autocapitalization(.none)
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }

    private var resetPasswordButton: some View {
        Button(action: {
            Task {
                await resetPassword()
            }
        }) {
            HStack {
                Text("Reset Password")
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(Color(.systemGreen))
        .cornerRadius(10)
        .padding()
    }

    private var additionalNavigationLinks: some View {
        VStack {
            NavigationLink(destination: FPasswordView().navigationBarBackButtonHidden(true)) {
                HStack(spacing: 3) {
                    Text("Try Another account?")
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
    }

    // MARK: - Private Methods
    private func validatePasswordMatch() {
        guard password == Cpassword else {
            showAlert = true
            alertMessage = "Passwords do not match."
            return
        }
    }

    private func resetPassword() async {
        do {
            validatePasswordMatch()

            let requestModel = ResetPasswordRequest(password: password, token: token)

            guard let url = URL(string: "http://127.0.0.1:3000/api/reset-password") else {
                showAlert = true
                alertMessage = "Invalid URL"
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let jsonData = try JSONEncoder().encode(requestModel)
            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)

            // Print received data and response status code
            print("Received Data: \(String(data: data, encoding: .utf8) ?? "No data")")
            print("Response Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Password Reset Successful!")
            } else {
                let errorData = try JSONDecoder().decode(ErrorData.self, from: data)
                print("Error: \(errorData.message)")
                showAlert = true
                alertMessage = "Password reset failed. \(errorData.message)"
            }
        } catch {
            print("Error: \(error)")
            showAlert = true
            alertMessage = "An error occurred. Please try again. \(error.localizedDescription)"
        }
    }
}

// MARK: - Preview
struct ResetPView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPView()
    }
}
