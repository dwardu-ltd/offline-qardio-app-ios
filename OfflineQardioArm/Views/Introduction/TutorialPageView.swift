//
//  TutorialPageView.swift
//  FuelPrices
//
//  Created by Edward Vella on 19/05/2025.
//

import SwiftUI

struct TutorialPageView: View {
    let page: TutorialPage
    
    var body: some View {
        VStack {
            page
        }
    }
}

#Preview {
    let page = TutorialPage(title: "This is a preview", description: "Preview Description", imageName: "Example")
    TutorialPageView(page: page)
}
