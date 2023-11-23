//
//  ProfileView.swift
//  PDM
//
//  Created by MacBook Pro on 14/11/2023.
//
// ProfileView.swift

import SwiftUI



struct ProfileView: View {
    var userProfile: UserProfile

    var body: some View {
        List {
            Section {
                HStack {
                    Text(String(userProfile.name.prefix(2))) // Displaying first two characters of the name as an example
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray3))
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text(userProfile.name)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        Text(userProfile.email)
                            .font(.footnote)
                            .accentColor(.gray)
                    }
                }
            }

            Section("General") {
                HStack {
                    SettingsRowView(imageName: "gear", title: "Profile", tintColor: Color(.systemGray))
                    Spacer()
                    Text("Edit")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Section("Account") {
                // Additional account-related information can be added here
            }
        }
        .background(Color(UIColor(red: 0.92, green: 0.94, blue: 0.89, alpha: 1.0)))
    }
}
