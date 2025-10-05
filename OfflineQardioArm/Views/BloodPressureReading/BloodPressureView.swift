import SwiftUI

struct BloodPressureView : View {
    @ObservedObject var bluetoothController: BluetoothController
    @ObservedObject var healthKitController: HealthKitController
    @ObservedObject var averageBloodPressureCoordinator: AverageBloodPressureCoordinator = AverageBloodPressureCoordinator.shared
    @AppStorage(Settings.saveToHealthKit) var saveToHealthKit: Bool = false
    @State var presentSingleBloodPressureReading = false
    @State var presentAverageBloodPressureReading = false
    @State private var showingReadingOptions = false
    
    private func onSuccessfulReading(_ bloodPressureReading: BloodPressureReading) {
        if (saveToHealthKit) {
           _ = healthKitController.saveBloodPressureReading(reading: bloodPressureReading)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                BloodPressureReadingView(reading: bluetoothController.bloodPressureReading)
                
                if bluetoothController.isDeviceConnected() {
                    Toggle(isOn: $healthKitController.guestReading) {
                        if (healthKitController.guestReading) {
                            Text("Your next reading will not be saved.")
                        } else {
                            Text("Guest Mode")
                        }
                    }
                    Divider()
                }
                
                Spacer()
                if (bluetoothController.bloodPressureReading.bloodPressureReadingProgress == .completed || bluetoothController.bloodPressureReading.bloodPressureReadingProgress == .savedToHealthKit) {
                    BloodPressureReadingChart(
                        reading: bluetoothController.bloodPressureReading)
                    .frame(height: 350)
                }
                Spacer()
                Divider()
                if (bluetoothController.isDeviceConnected() &&
                    bluetoothController.batteryLevel < 25) {
                    Text("Change your device's batteries, it might fail to take a reading.")
                        .foregroundStyle(.red)
                        .bold()
                    Divider()
                }
                VStack {
                    
                    HStack {
                        if bluetoothController.isDeviceConnected() {
                             DeviceConnectionMinifiedView(
                                deviceName: bluetoothController.getDeviceName(),
                                isConnected: bluetoothController.isDeviceConnected(),
                                batteryLevel: bluetoothController.batteryLevel
                            )
                            Spacer()
                            
                            Button("Get Reading"){
                                averageBloodPressureCoordinator.reset()
                                showingReadingOptions = true
                            }.sheet(isPresented: $presentSingleBloodPressureReading) {
                                if (saveToHealthKit) {
                                    _ = healthKitController.saveBloodPressureReading(reading: bluetoothController.bloodPressureReading)
                                }
                            } content: {
                                BloodPressureReadingInActionView()
                            }
                            .sheet(isPresented: $presentAverageBloodPressureReading) {
                                if (saveToHealthKit && averageBloodPressureCoordinator.hasReadings) {
                                    _ = healthKitController.saveBloodPressureReading(reading: bluetoothController.bloodPressureReading)
                                }
                                
                            } content: {
                                AverageBloodPressureReadingInActionView()
                            }
                            .confirmationDialog("Select Reading Type", isPresented: $showingReadingOptions, titleVisibility: .visible) {
                                Button("Single Reading") {
                                    presentSingleBloodPressureReading = true
                                }
                                Button("Average Reading") {
                                    presentAverageBloodPressureReading = true
                                }
                            }
                        }
                        else {
                            Spacer()
                            Button("Connect to QardioArm") {
                                bluetoothController.scanForPeripherals()
                            }
                            Spacer()
                        }
                    }
                }
                
            }
            .padding()
            .navigationTitle("Blood Pressure")
            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    DeviceConnectionMinifiedView(
//                        deviceName: bluetoothController.getDeviceName(),
//                        isConnected: bluetoothController.isDeviceConnected(),
//                        batteryLevel: bluetoothController.batteryLevel
//                    )
//                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    
                }
            }
        }
    }
}

#Preview {
    let bloodPressureReading = BloodPressureReading(systolic: 115, diastolic: 60, atrialPressure: 78, pulseRate: 65, bloodPressureReadingProgress: .savedToHealthKit)
    var bluetoothControllerFakeData: BluetoothController = BluetoothController.controllerWithSampleData(reading: bloodPressureReading, batteryLevel: 78)
    
    BloodPressureView(bluetoothController:  bluetoothControllerFakeData, healthKitController: HealthKitController())
}
