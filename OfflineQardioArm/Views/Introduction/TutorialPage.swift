//
//  TutorialPage.swift
//  FuelPrices
//
//  Created by Edward Vella on 19/05/2025.
//

import SwiftUI

struct TutorialPage: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    let description: String
    let imageName: String
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
            Text(description)
                .font(.body)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TutorialPage(title: "Title Page", description: "This is a description of the tutorial", imageName: "AppleHealthIcon")
}

