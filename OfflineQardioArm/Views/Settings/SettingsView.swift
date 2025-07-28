//
//  SettingsView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 28/07/2025.
//

import SwiftUI


struct SettingsView : View {
    @AppStorage(Settings.saveToHealthKit) var saveToHealthKit: Bool = false
    
    var body : some View {
        Text("Settings")
            .font(.title2)
        VStack {
            List {
                Section(header: Text("Health App")) {
                    HealthAppAuthorisationStatusView()
                    Toggle(isOn: $saveToHealthKit) {
                        Text("Save Readings to Health App")
                    }
                    .padding()
                }
                .headerProminence(.increased)
            }
        }
        CopyrightView()
    }
}


#Preview {
    SettingsView()
}
