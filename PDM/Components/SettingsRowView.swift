//
//  SettingsRowView.swift
//  PDM
//
//  Created by MacBook Pro on 14/11/2023.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text (title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Profile", tintColor: Color(.systemGray))
}
