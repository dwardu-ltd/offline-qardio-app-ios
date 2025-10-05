//
//  ContentView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 25/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("tutorialCompleted") var tutorialCompleted = false
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var bluetoothController: BluetoothController
    @ObservedObject var healthKitController: HealthKitController
    @AppStorage(Settings.saveToHealthKit) var saveToHealthKit: Bool = false

    var body: some View {
        if (!tutorialCompleted) {
            TutorialView()
        } else {
            BloodPressureView(bluetoothController: self.bluetoothController, healthKitController: self.healthKitController)
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    print("Active")
                    UIApplication.shared.isIdleTimerDisabled = true
                    bluetoothController.scanForPeripherals()
                } else if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .background {
                    print("Disappeared")
                    UIApplication.shared.isIdleTimerDisabled = false
                    bluetoothController.disconnectPeripheral()
                }
            }
            .onAppear() {
                UIApplication.shared.isIdleTimerDisabled = true
                bluetoothController.scanForPeripherals()
            }
            .onDisappear() {
                print("Disappeared")
                UIApplication.shared.isIdleTimerDisabled = false
                bluetoothController.disconnectPeripheral()
            }

        }
    }
}

#Preview {
    let healthKitController: HealthKitController = HealthKitController()
    let bloodPressureReading = BloodPressureReading(systolic: 115, diastolic: 60, atrialPressure: 78, pulseRate: 65, bloodPressureReadingProgress: .savedToHealthKit)
    var bluetoothControllerFakeData: BluetoothController = BluetoothController.controllerWithSampleData(reading: bloodPressureReading, batteryLevel: 78)
    
    ContentView(tutorialCompleted: true, bluetoothController: bluetoothControllerFakeData, healthKitController: healthKitController)
}
