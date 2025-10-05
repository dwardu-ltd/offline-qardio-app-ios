//
//  AverageBloodPressureReading.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 10/08/2025.
//
// Follow https://www.avanderlee.com/swiftui/presenting-sheets/ for a better usage of sheets

import Foundation
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
//            ScrollView {
////                ForEach(averageBloodPressureCoordinator.bloodPressureReadings.indices, id: \.self)
////                { index in
////                    Text("Reading \(index + 1)")
////                        .font(.headline)
////                    BloodPressureReadingView(reading: averageBloodPressureCoordinator.bloodPressureReadings[index])
////                        .padding(.bottom, 10)
////                }
//                
//                
//            }
            HStack {
                
                    Button("Cancel") {
                        averageBloodPressureCoordinator.reset()
                        dismiss()
                    }.foregroundStyle(.red)
                    .padding()
                
                Spacer()
            }.padding()
            Spacer()
            if averageBloodPressureCoordinator.bloodPressureReadings.isEmpty {
                Text("No readings taken yet")
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                Text("Average of \(readingsCount) readings")
                    .font(.headline)
                    .padding(.top, 10)
                BloodPressureReadingView(reading: averageBloodPressureCoordinator.averageBloodPressureReadings())
            }
            Spacer()
            if averageBloodPressureCoordinator.allReadingsCompleted() {
                Text("All readings completed")
                Button ("Complete") {
                    bluetoothController.bloodPressureReading = averageBloodPressureCoordinator.averageBloodPressureReadings()
                    dismiss()
                }
                .foregroundColor(.green)
            } else {
                
                let text = getReadingText(readingsCount, maximumReadings)

                HStack {
                    if readingsCount > 0 {
                        Button ("Use Current Average") {
                            bluetoothController.bloodPressureReading = averageBloodPressureCoordinator.averageBloodPressureReadings()
                            dismiss()
                        }
                    }
                    Spacer()
                    Button (text) {
                        // Start a new reading
                        presentBloodPressureReading = true
                    }.sheet(isPresented: $presentBloodPressureReading) {
                        if (bluetoothController.bloodPressureReading.bloodPressureReadingProgress == .completed || bluetoothController.bloodPressureReading.bloodPressureReadingProgress == .savedToHealthKit) {
                            averageBloodPressureCoordinator.bloodPressureReadings.append(bluetoothController.bloodPressureReading)
                        }
                        bluetoothController.stopReading()
                        
                    } content: {
                        BloodPressureReadingInActionView()
                    }
                }.padding()
            }
        }
    }
    func getReadingText(_ currentReading: Int, _ maximumReadings: Int) -> String {
        if currentReading == 0 {
            return "Take Reading"
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
    var averageBloodPressureCoordinator = AverageBloodPressureCoordinator.controllerWithSampleData(currentReadings: 1, maximumReadings: 4)

    AverageBloodPressureReadingInActionView( averageBloodPressureCoordinator: averageBloodPressureCoordinator)
}
