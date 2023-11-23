import SwiftUI

struct ContentView: View {
    @State private var shouldShowRegistration = false
    @State private var shouldShowLogin = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("backgroundImage")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                Image("logo.png")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 220)
                    .padding(.top, 12)

                VStack {
                    Spacer()

                    NavigationLink(
                        destination: RegistrationView().navigationBarBackButtonHidden(true),
                        isActive: $shouldShowRegistration
                    ) {
                        EmptyView()
                    }

                    Button(action: {
                        withAnimation {
                            shouldShowRegistration.toggle()
                        }
                    }) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(.systemGreen))
                            .cornerRadius(10)
                    }
                    .padding()

                    NavigationLink(
                        destination: LoginView().navigationBarBackButtonHidden(true),
                        isActive: $shouldShowLogin
                    ) {
                        EmptyView()
                    }

                    Button(action: {
                        withAnimation {
                            shouldShowLogin.toggle()
                        }
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(.systemBlue))
                            .cornerRadius(10)
                    }
                    .padding()

                    Spacer()
                }
                .padding()
            }
        }
    }
}
