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
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    @State private var healthKitError: String?
    @State private var showAuthorizationAlert = false
    
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
            }
            Spacer()
            HStack {
                if !healthKitController.healthDataAuthorized {
                    Button(action: {
                        Task {
                            do {
                                try await healthKitController.requestAuthorization()
                                let authorized = healthKitController.isAuthorized()
                                if !authorized {
                                    showAuthorizationAlert = true
                                } else {
                                    showAuthorizationAlert = false
                                }
                            } catch {
                                healthKitError = error.localizedDescription
                                showAuthorizationAlert = true
                            }
                        }
                    }) {
                        Text("Allow")
                    }
                }
            }
        }
        .onAppear {
            _ = healthKitController.isAuthorized()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                _ = healthKitController.isAuthorized()
            }
        }
        .alert("Health Access Required", isPresented: $showAuthorizationAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Open Health") {
                if let healthURL = URL(string: "x-apple-health://sources") {
                    openURL(healthURL)
                }
            }
        } message: {
            Text("OfflineQardioArm needs Health access. Open Apple Health, then go to your profile > Apps > OfflineQardioArm and enable blood pressure permissions.")
        }
    }
}

#Preview {
    HealthAppAuthorisationStatusView()
}
