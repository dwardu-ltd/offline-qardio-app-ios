//
//  SetUpHealthKitView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 29/07/2025.
//

import SwiftUI
import Foundation
//A view that explains to the user how to
struct SetUpHealthKitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var healthKitController: HealthKitController = HealthKitController.shared
    @AppStorage(Settings.saveToHealthKit) var saveToHealthKit: Bool = false
    var body: some View {
        VStack {
            Text("Apple Health")
                .font(.title)
            Spacer()
            Image("AppleHealthIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                
            Spacer()
        if (healthKitController.healthDataAuthorized) {
//            Show a success message indicating to the user that theyre already authenticated to health app
            VStack {
                Text("Awesome you've allowed with the Health App")
                Toggle(isOn: $saveToHealthKit) {
                    Text("Save readings to Apple Health")
                }.padding()
                Spacer()
                
            }.padding(.top)
        } else {
            VStack {
                Text("This app allows you to automatically store readings you take with the blood pressure monitor to the Health App. If you deny it now, then you'll need to authorise it in the Health App.")
                    .font(.body)
                
                Spacer()
                HStack {
                    Spacer()
                    Button(action:{
                        self.dismiss()
                        
                    }) {
                        Text("Deny")
                    }.foregroundColor(.red)
                    Spacer()
                    Button(action:{
                        Task() {
                            try await healthKitController.requestAuthorization()
                            _ = healthKitController.isAuthorized()
                        }
                    }) {
                        Text("Allow")
                    }
                    Spacer()
                }
                
            }.padding(.top)
        }
           
        } .padding()
    }
}

#Preview {
    SetUpHealthKitView()
}
