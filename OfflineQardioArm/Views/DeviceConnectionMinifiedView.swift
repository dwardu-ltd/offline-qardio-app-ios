//
//  DeviceConnectionStatusView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 26/07/2025.
//

import SwiftUI
import Foundation

struct DeviceConnectionMinifiedView: View {
    
    let deviceName: String
    let isConnected: Bool
    let batteryLevel: UInt8 // Optional battery level, if available
    
    var body: some View {
        HStack {
            Image(systemName: isConnected ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isConnected ? .green : .red)
                .font(.body)
            
            
            Text(isConnected ? deviceName : "No Device")
                .font(.body)
                .foregroundColor(.primary)
            if (isConnected) {
                BatteryLevelView(batteryLevel: batteryLevel)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DeviceConnectionMinifiedView(deviceName: "QardioArm", isConnected: true, batteryLevel: 95)
        .padding()
    DeviceConnectionMinifiedView(deviceName: "QardioArm", isConnected: true, batteryLevel: 85)
        .padding()
    DeviceConnectionMinifiedView(deviceName: "QardioArm", isConnected: true, batteryLevel: 55)
        .padding()
    DeviceConnectionMinifiedView(deviceName: "QardioArm", isConnected: true, batteryLevel: 45)
        .padding()
    DeviceConnectionMinifiedView(deviceName: "QardioArm", isConnected: true, batteryLevel: 35)
        .padding()
    DeviceConnectionMinifiedView(deviceName: "QardioArm", isConnected: true, batteryLevel: 15)
        .padding()
    DeviceConnectionMinifiedView(deviceName: "QardioArm", isConnected: false, batteryLevel: 5)
        .padding()
}
