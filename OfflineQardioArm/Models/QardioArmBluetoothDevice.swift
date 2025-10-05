//
//  QardioArmBluetoothDevice.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 26/07/2025.
//
import CoreBluetooth

struct QardioArmBluetoothDevice {
    static let batteryServiceId: UInt16 = 0x180F
    static let batteryServiceName: String = "Battery"
    static let batteryServiceString: String = "180F"
    static let batteryServiceLevelCharacteristicId: CBUUID = CBUUID(string: QardioArmBluetoothDevice.batteryServiceLevelCharacteristicString)
    static let batteryServiceLevelCharacteristicString: String = "2A19"
    
    static let bloodPressureServiceId: UInt16 = 0x1810
    static let bloodPressureServiceName: String = "Bloody Pressure" // Looks like Qardio named this service "Bloody Pressure" instead of "Blood Pressure" from the BLE spec
    static let bloodPressureServiceString: String = "1810"
    static let bloodPressureMeasurementCharacteristicId: UInt16 = 0x2A35
    static let bloodPressureMeasurementCharacteristicString: String = "2A35"
    static let bloodPressureFeatureCharacteristicId: CBUUID = CBUUID(string: "583CB5B3-875D-40ED-9098-C39EB0C1983D")
    static let bloodPressureFeatureStartReadingValue: UInt16 = 0x01F1
    static let bloodPressureFeatureStopReadingValue: UInt16 = 0x02F1
    
    var batteryLevel: UInt8 = 0
}
