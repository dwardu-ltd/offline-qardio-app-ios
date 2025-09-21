//
//  OfflineQardioArmApp.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 25/07/2025.
//

import SwiftUI
import SwiftData

@main
struct OfflineQardioArmApp: App {
    
    var bluetoothController: BluetoothController = BluetoothController.shared
    var healthKitController: HealthKitController = HealthKitController.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            #if targetEnvironment(simulator)
            let bloodPressureReading = BloodPressureReading(systolic: 122, diastolic: 83, atrialPressure: 99, pulseRate: 66, bloodPressureReadingProgress: .savedToHealthKit)
            let bluetoothControllerFakeData: BluetoothController = BluetoothController.controllerWithSampleData(reading: bloodPressureReading, batteryLevel: 78)
            ContentView(bluetoothController: bluetoothControllerFakeData, healthKitController: healthKitController)
            #else
            ContentView(bluetoothController: bluetoothController, healthKitController: healthKitController)
            #endif
        }
        .modelContainer(sharedModelContainer)
    }
}
