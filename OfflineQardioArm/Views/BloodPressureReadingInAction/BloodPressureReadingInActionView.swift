//
//  BloodPressureReadingInActionView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 10/08/2025.
//

import SwiftUI

struct BloodPressureReadingInActionView : View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var bluetoothController: BluetoothController = BluetoothController.shared
    @ObservedObject var healthKitController: HealthKitController = HealthKitController.shared
    
    private func onSuccessfulReading(_ bloodPressureReading: BloodPressureReading) {
        onCompleted()
    }
    
    
    func onCompleted() {
        self.dismiss()
    }
    
    var body: some View {
        HStack {
                BloodPressureReadingView(reading: bluetoothController.bloodPressureReading)
        }
        .onAppear {
            bluetoothController.startReading(onSuccessfulReading: self.onSuccessfulReading(_:))
        }
    }
}

#Preview {
    let bloodPressureReading = BloodPressureReading(systolic: 115, diastolic: 60, atrialPressure: 78, pulseRate: 65, bloodPressureReadingProgress: .savedToHealthKit)
    var bluetoothControllerFakeData: BluetoothController = BluetoothController.controllerWithSampleData(reading: bloodPressureReading, batteryLevel: 78)
    
    BloodPressureReadingInActionView(bluetoothController: bluetoothControllerFakeData)
}
