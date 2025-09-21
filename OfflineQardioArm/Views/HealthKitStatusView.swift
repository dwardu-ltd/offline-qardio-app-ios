//
//  HealthKitStatusView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 26/07/2025.
//

import SwiftUI
import HealthKitUI
import Foundation

struct HealthKitStatusView: View {
    
    @ObservedObject private var healthKitController = HealthKitController.shared
    var reading: BloodPressureReading
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
            
            Spacer()
            if (!healthKitController.healthDataAuthorized) {
                Button(action: {
                    Task() {
                        try await healthKitController.requestAuthorization()
                        _ = healthKitController.isAuthorized()
                    }
                }) {
                    Text("Authenticate HealthKit")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            } else {
                if (reading.bloodPressureReadingProgress == .completed) {
                    Button(action: {
                        _ = healthKitController.saveBloodPressureReading(reading: reading)
                    })
                    {
                        if(!reading.syncedToHealth) {
                            Text("Save to HealthKit")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

#Preview {
    HealthKitStatusView(reading: BloodPressureReading(systolic: 120, diastolic: 80, atrialPressure: 68, pulseRate: 70, bloodPressureReadingProgress: .completed))
        .padding()
}
