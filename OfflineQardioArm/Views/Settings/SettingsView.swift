import SwiftUI


struct SettingsView : View {
    @AppStorage(Settings.saveToHealthKit) var saveToHealthKit: Bool = false
    @AppStorage("tutorialCompleted") var tutorialCompleted = false
    var bluetoothController: BluetoothController = BluetoothController.shared
    
    var body : some View {
        Text("Settings")
            .font(.title2)
        VStack {
            List {
                Section(header: Text("Device")) {
                    DeviceConnectionStatusView(
                        deviceName: bluetoothController.getDeviceName(),
                        isConnected: bluetoothController.isDeviceConnected(),
                        batteryLevel: bluetoothController.batteryLevel
                    )
                }
                Section(header: Text("Health App")) {
                    HealthAppAuthorisationStatusView()
                    Toggle(isOn: $saveToHealthKit) {
                        Text("Save readings to Apple Health")
                    }
                }
                .headerProminence(.increased)
                Section(header: Text("Tutorial")) {
                    Button("Restart Tutorial") {
                        tutorialCompleted.toggle()
                    }
                }
            }
        }
        CopyrightView()
    }
}


#Preview {
    SettingsView()
}
