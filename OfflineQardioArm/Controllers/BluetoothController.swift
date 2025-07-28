//
//  BluetoothController.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 25/07/2025.
//

import CoreBluetooth

class BluetoothController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    @Published var isBluetoothEnabled: Bool = false
    @Published var batteryLevel: UInt8 = 0 // Default value for battery level
    @Published var connectedPeripheral: CBPeripheral?
    @Published var bloodPressureReading: BloodPressureReading = BloodPressureReading(
        systolic: 0,
        diastolic: 0,
        atrialPressure: 0,
        pulseRate: 0,
        bloodPressureReadingProgress: .notStarted
    )
    private var onSuccessfulReading: ((BloodPressureReading) -> Void)?
    
    private var centralManager: CBCentralManager!
    
    private var characteristic: CBCharacteristic?
    private var readingCharacteristic: CBCharacteristic?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    /*
        Bluetooth Peripheral Related
     */
    
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: (any Error)?
    ) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            print("Discovered service: \(service.uuid)")
            switch service.uuid {
            case CBUUID(string: QardioArmBluetoothDevice.bloodPressureServiceString): // Blood Pressure Service UUID
                print("Blood Pressure Service found")
                // Discover characteristics for Blood Pressure Service
                
                peripheral.discoverCharacteristics(nil, for: service) // Discover all characteristics
            case CBUUID(string: QardioArmBluetoothDevice.batteryServiceString): // Battery Service UUID
                print("Battery Service found")
                // Discover characteristics for Battery Service
                peripheral.discoverCharacteristics(nil, for: service) // Discover all characteristics
            default:
                print("Unknown service UUID: \(service.uuid)")
                // You can handle other services here if needed
                // peripheral.discoverCharacteristics(nil, for: service)
                break
            }
        }
    }
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: (any Error)?
    )
    {
        if let error = error {
            print("Error updating value for characteristic \(characteristic.uuid): \(error.localizedDescription)")
            return
        }
        
        guard let data = characteristic.value else { return }
        
        // Handle the received data based on the characteristic UUID
       
        switch characteristic.uuid {
        case CBUUID(string: QardioArmBluetoothDevice.bloodPressureMeasurementCharacteristicString): // Blood Pressure Measurement Characteristic UUID
            print("Received Blood Pressure Measurement data: \(data)")
            // Parse the data as needed, e.g., convert to BloodPressureReading model
            // For example, let's assume the data is in a specific format:
            if data.count >= 6 {
                // Assuming the data format is:
                // [Systolic (2 bytes), Diastolic (2 bytes), Atrial Pressure (2 bytes), Pulse Rate (2 bytes)]
                
                // Try get the values, because they may not always be there
                //     Systolic is the first 1 bytes, then diastolic is 3, arterialPressure is 5, and pulseRate is 7
                // Blood pressure reading format is (bytes): Flags (1), Systolic (2), Diastolic (2), Arterial Pressure(2), Pulse Rate (2), Measurement Status (2)
                let flags = data[0]
                
                let systolicData = data.subdata(in: 1..<3)
                let systolic = systolicData.withUnsafeBytes { $0.load(as: UInt16.self) }
                let diastolicData = data.subdata(in: 3..<5)
                let diastolic = diastolicData.withUnsafeBytes { $0.load(as: UInt16.self) }
                let atrialPressureData = data.subdata(in: 5..<7)
                let atrialPressure = atrialPressureData.withUnsafeBytes { $0.load(as: UInt16.self) }
                
                // Pulse Rate is optional, so we check if it exists
                // If pulse rate is not provided, we can set it to a default value
                // Assuming pulse rate is the next 2 bytes after atrial pressure
                var pulseRate: UInt16 = 0
                var bloodPressureReadingProgress: BloodPressureReadingProgress = .started
                if (data.count > 7) {
                    let pulseRateData = data.subdata(in: 7..<9)
                    pulseRate = pulseRateData.withUnsafeBytes { $0.load(as: UInt16.self) }
                    if flags == 20 {
                        // If flags indicate that the pulse rate is not present, we set it to 0
                        bloodPressureReadingProgress = .completed
                    } else {
                        bloodPressureReadingProgress = .failed
                    }
                    if (systolic > 200) {
                        print("Errored")
                    }
                    
                    if (data.count > 9) {
                        let measurementStatusData = data.subdata(in: 9..<11)
                        
                        let measurementStatus = measurementStatusData.withUnsafeBytes { $0.load(as: UInt16.self) }
                        print(measurementStatus)
                    }
                }
                
                self.bloodPressureReading.systolic = systolic
                self.bloodPressureReading.diastolic = diastolic
                self.bloodPressureReading.atrialPressure = atrialPressure
                self.bloodPressureReading.pulseRate = pulseRate
                self.bloodPressureReading.bloodPressureReadingProgress = bloodPressureReadingProgress
                
                    print("Flags: \(flags)")
                    print("Blood Pressure Reading: Systolic: \(systolic) mmHg, Diastolic: \(diastolic) mmHg, Atrial Pressure: \(atrialPressure) mmHg, Pulse Rate: \(pulseRate) bpm")
                if (bloodPressureReadingProgress == .completed) {
                    guard let onSuccessfulReading = self.onSuccessfulReading else {
                        return
                    }
                    onSuccessfulReading(self.bloodPressureReading)
                    
                }
            } else {
                print("Received data is not in the expected format.")
            }
        case CBUUID(string: QardioArmBluetoothDevice.batteryServiceLevelCharacteristicString): // Battery Level Characteristic UUID
            print("Received Battery Level data: \(data)")
            // Parse the battery level data
            if let batteryLevel = data.first {
                print("Battery Level: \(batteryLevel)%")
                // Update the battery level in the QardioArmBluetoothDevice model
                self.batteryLevel = batteryLevel
            } else {
                print("Battery Level data is not available.")
            }
        default:
            print("Received data for unknown characteristic: \(characteristic.uuid)")
        }
    }
    func peripheral(
        _ peripheral: CBPeripheral,
        didWriteValueFor characteristic: CBCharacteristic,
        error: (any Error)?
    )
    {
        if let error = error {
            print("Error writing value for characteristic \(characteristic.uuid): \(error.localizedDescription)")
        } else {
            print("Successfully wrote value for characteristic: \(characteristic.uuid)")
            // Optionally, you can read the value back if needed
//            peripheral.readValue(for: self.readingCharacteristic!)
            // print all of characteristic
            
            print("Characteristic UUID: \(characteristic.uuid)")
            if let value = characteristic.value {
                print("Characteristic Value: \(value.map { String(format: "%02X", $0) }.joined())")
            } else {
                print("Characteristic Value is nil")
            }
            
            
        }
    }
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: (any Error)?
    ) {
        print("Discovered characteristics for service: \(service.uuid)")
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic.uuid)")
            switch characteristic.uuid {
            case QardioArmBluetoothDevice.bloodPressureFeatureCharacteristicId: // Blood Pressure Measurement Characteristic UUID
                print("Blood Pressure Measurement Characteristic found")
                peripheral.setNotifyValue(true, for: characteristic) // Subscribe to notifications
                print("Subscribed to Blood Pressure Measurement Characteristic")
                self.characteristic = characteristic // Store the characteristic for later use
            case CBUUID(string: QardioArmBluetoothDevice.bloodPressureMeasurementCharacteristicString): // Blood Pressure Service UUID
                print("Pressure reading Characteristic found")
                self.readingCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic) // Subscribe to notifications
            case CBUUID(string: QardioArmBluetoothDevice.batteryServiceLevelCharacteristicString): // Battery Level Characteristic UUID
                print("Battery Level Characteristic found")
                peripheral.setNotifyValue(true, for: characteristic) // Subscribe to notifications
            default:
                break
            }
        }
    }
    func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateNotificationStateFor characteristic: CBCharacteristic,
        error: (any Error)?
    ) {
        if let error = error {
            print("Error updating notification state for characteristic \(characteristic.uuid): \(error.localizedDescription)")
        } else {
            print("Notification state updated for characteristic: \(characteristic.uuid), isNotifying: \(characteristic.isNotifying)")
        }
    }
     
    
    
    private func convertToHex(_ value: UInt16) -> String {
        return String(format: "%04X", value)
    }
//    convert a string to bytes
    private func stringToBytes(_ value: String) -> [UInt8]? {
        guard let hexValue = UInt16(value, radix: 16) else { return nil }
        return [UInt8(hexValue >> 8), UInt8(hexValue & 0xFF)]
    }
    
//    convert a ushort to bytes
    private func ushortToBytes(_ value: UInt16) -> [UInt8] {
        return [UInt8(value >> 8), UInt8(value & 0xFF)]
    }
//    Convert decimal 497 to UInt8
    private func decimalToUInt8(_ value: UInt16) -> UInt8 {
        return UInt8(value & 0xFF)
    }
    func hexToData(_ value: UInt16, bigEndian: Bool = true) -> Data {
        return withUnsafeBytes(of: bigEndian ? value.bigEndian : value.littleEndian) { Data($0) }
    }
    
    
    func startReading(onSuccessfulReading: ((BloodPressureReading) -> Void)?) {
        if connectedPeripheral != nil {
            print("Reading from connected peripheral: \(connectedPeripheral?.name ?? "Unknown")")
            print("Peripheral Identifier: \(connectedPeripheral?.identifier.uuidString ?? "Unknown")")
            print("Is Connected? \(connectedPeripheral?.state == .connected ? "Yes" : "No")")
            
            print("Writing value to characteristic: \(String(describing: characteristic?.uuid))")
            self.onSuccessfulReading = onSuccessfulReading
            connectedPeripheral?.writeValue(hexToData(QardioArmBluetoothDevice.bloodPressureFeatureStartReadingValue, bigEndian: false), for: self.characteristic!, type: .withResponse)
        } else {
            print("No connected peripheral to read from.")
        }
    }
    
    func scanForPeripherals() {
        if isBluetoothEnabled {
            let services: [CBUUID] = [CBUUID(string: QardioArmBluetoothDevice.bloodPressureServiceString), CBUUID(string: QardioArmBluetoothDevice.batteryServiceString)] // Battery and Blood Pressure Service UUID respectively
            centralManager.scanForPeripherals(withServices: services, options: nil)
        }
    }
    
    func disconnectPeripheral() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
            print("Disconnected from peripheral: \(peripheral.name ?? "Unknown")")
            connectedPeripheral = nil
        } else {
            print("No connected peripheral to disconnect from.")
        }
    }
    
    /*
     
     Core Bluetooth Central Manager Related
     
     */
    func centralManager(_ didConnect: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        self.connectedPeripheral = peripheral
        self.connectedPeripheral?.delegate = self
        print("Connected to peripheral: \(peripheral.name ?? "Unknown")")
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: QardioArmBluetoothDevice.bloodPressureServiceString), CBUUID(string: QardioArmBluetoothDevice.batteryServiceString)]) // Blood Pressure Service UUID
    }
    
    func centralManager(_ didFailToConnect: CBCentralManager, peripheral: CBPeripheral, error: (any Error)?) {
        if let error = error {
            print("Failed to connect to peripheral: \(error.localizedDescription)")
        } else {
            print("Failed to connect to peripheral: \(peripheral.name ?? "Unknown")")
        }
        self.connectedPeripheral = nil
    }
    
    func centralManager(
        _ central: CBCentralManager,
        connectionEventDidOccur event: CBConnectionEvent,
        for peripheral: CBPeripheral
    ) {
        
        print("Connection event occurred: \(event) for peripheral: \(peripheral.name ?? "Unknown")")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.connectedPeripheral = peripheral
        self.connectedPeripheral?.delegate = self
        print("Peripheral discovered:")
        // Print peripheral name and identifier
        
        print("Peripheral Name : \(peripheral.name ?? "Unknown Peripheral")")
        print("Peripheral Identifier : \(peripheral.identifier)")
        // Connect to the peripheral
        centralManager?.connect(peripheral, options: nil)
        print("Connecting to peripheral: \(peripheral.name ?? "Unknown")")
        // Stop scanning after discovering a peripheral
        // This is optional, you can keep scanning if you want to discover more peripherals
        // If you want to stop scanning after connecting to one peripheral, uncomment the next line
        //
        
        centralManager?.stopScan()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.authorization {
        case .notDetermined:
            print("Bluetooth authorization not determined.")
        case .restricted:
            print("Bluetooth authorization restricted.")
        case .denied:
            print("Bluetooth authorization denied.")
        case .allowedAlways:
            print("Bluetooth authorization allowed always.")
        }
        switch central.state {
        case .unauthorized:
            isBluetoothEnabled = false
            break
        case .unknown:
            break
        case .unsupported:
            break
        case .poweredOn:
            isBluetoothEnabled = true
            scanForPeripherals()
            break
        case .poweredOff:
            self.connectedPeripheral = nil
            break
        case .resetting:
            self.connectedPeripheral = nil
            break
        default:
            isBluetoothEnabled = false
        }
    }
}




