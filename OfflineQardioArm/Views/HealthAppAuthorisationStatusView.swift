//
//  HealthKitStatusView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 26/07/2025.
//

import SwiftUI
import HealthKitUI
import Foundation

struct HealthAppAuthorisationStatusView: View {
    
    @ObservedObject private var healthKitController = HealthKitController.shared
    @State private var healthKitError: String?
    
    @State var authenticated = false
    @State var trigger = false
    
    
    var body: some View {
        HStack {
            Image(systemName:healthKitController.healthDataAuthorized ? "heart.fill" : "heart.slash.fill" )
                .foregroundColor(.red)
                .font(.title)
            
            VStack(alignment: .leading) {
                Text("HealthKit")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if healthKitController.healthDataAuthorized {
                    Text("Authenticated")
                        .foregroundColor(.green)
                } else {
                    Text("Not Authenticated")
                        .foregroundColor(.red)
                }
                
                if let error = healthKitError {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    HealthAppAuthorisationStatusView()
}
