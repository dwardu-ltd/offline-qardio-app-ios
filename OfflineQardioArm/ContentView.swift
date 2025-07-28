//
//  ContentView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 25/07/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var bluetoothController = BluetoothController()
    @ObservedObject private var healthKitController = HealthKitController.shared
    @AppStorage(Settings.saveToHealthKit) var saveToHealthKit: Bool = false
    
    private func onSuccessfulReading(_ bloodPressureReading: BloodPressureReading) {
        if (saveToHealthKit) {
            healthKitController.saveBloodPressureReading(reading: bloodPressureReading)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                BloodPressureReadingView(reading: bluetoothController.bloodPressureReading)
                    .padding()
                Spacer()
                if (bluetoothController.bloodPressureReading.bloodPressureReadingProgress == .completed) {
                    BloodPressureReadingChart(
                        reading: bluetoothController.bloodPressureReading)
                }
                HStack {
                    if bluetoothController.connectedPeripheral != nil {
                        Button("Disconnect") {
                            bluetoothController.disconnectPeripheral()
                        }
                    }
                    else {
                        Button("Connect to QardioArm") {
                            bluetoothController.scanForPeripherals()
                        }
                    }
                    Spacer()
                    if bluetoothController.connectedPeripheral != nil {
                            Button("Get Reading") {
                                bluetoothController.startReading(onSuccessfulReading: onSuccessfulReading)
                            }
                    }
                } .padding()
            }
            .navigationTitle("Blood Pressure")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DeviceConnectionMinifiedView(
                        deviceName: bluetoothController.connectedPeripheral?.name ?? "",
                        isConnected: bluetoothController.connectedPeripheral != nil,
                        batteryLevel: bluetoothController.batteryLevel
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                      SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    
                }
            }
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
    ContentView()
}
