//
//  AverageBloodPressureReading.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 10/08/2025.
//

import SwiftUI

struct AverageBloodPressureReadingInActionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var bluetoothController: BluetoothController = BluetoothController.shared
    @ObservedObject var averageBloodPressureCoordinator: AverageBloodPressureCoordinator = AverageBloodPressureCoordinator.shared
    
    @State var presentBloodPressureReading = false
    
    let maximumReadings: Int = 3
    let secondsToWait: Int8 = 15
    
    var readingsCount: Int {
        return averageBloodPressureCoordinator.bloodPressureReadings.count
    }
    
    var body: some View {
        VStack {
            if averageBloodPressureCoordinator.allReadingsCompleted() {
                Text("All readings completed")
                Button ("Complete") {
                    bluetoothController.bloodPressureReading = averageBloodPressureCoordinator.averageBloodPressureReadings()
                    dismiss()
                }
            } else {
                Text("Reading \(readingsCount + 1) of \(maximumReadings)")
//                let text = readingsCount > 0 ? "Wait \(secondsToWait) seconds before next reading" : "Press Next Reading to start"
//                
//                Text(text)
                
                let text = getReadingText(readingsCount, maximumReadings)
                Button ("Next Reading") {
                    // Start a new reading
                    presentBloodPressureReading = true
                }.sheet(isPresented: $presentBloodPressureReading) {
                    averageBloodPressureCoordinator.bloodPressureReadings.append(bluetoothController.bloodPressureReading)
                } content: {
                    BloodPressureReadingInActionView()
                }
            }
        }
    }
    func getReadingText(_ currentReading: Int, _ maximumReadings: Int) -> String {
        if currentReading == 0 {
            return "Press Next Reading to start"
        } else if (maximumReadings - currentReading) == 1 {
            return "Last Reading"
        } else  {
            return "Next Reading"
        }
    }
}


#Preview {
    
    let bloodPressureReading = BloodPressureReading(systolic: 115, diastolic: 60, atrialPressure: 78, pulseRate: 65, bloodPressureReadingProgress: .savedToHealthKit)
    var bluetoothControllerFakeData: BluetoothController = BluetoothController.controllerWithSampleData(reading: bloodPressureReading, batteryLevel: 78)
    let averageBloodPressureCoordinator = AverageBloodPressureCoordinator()
    AverageBloodPressureReadingInActionView( averageBloodPressureCoordinator: averageBloodPressureCoordinator)
}
