//
//  DeviceConnectionStatusView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 26/07/2025.
//

import SwiftUI
import Foundation

struct DeviceConnectionStatusView: View {
    
    let deviceName: String
    let isConnected: Bool
    let batteryLevel: UInt8 // Optional battery level, if available
    
    var body: some View {
        HStack {
            Image(systemName: isConnected ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isConnected ? .green : .red)
                .font(.title)
            
            
            Text(isConnected ? "\(deviceName) (\(batteryLevel)%)" : deviceName)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(isConnected ? "Connected" : "Disconnected")
                .font(.subheadline)
                .foregroundColor(isConnected ? .green : .red)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DeviceConnectionStatusView(deviceName: "QardioArm", isConnected: true, batteryLevel: 85)
        .padding()
    DeviceConnectionStatusView(deviceName: "QardioArm", isConnected: false, batteryLevel: 5)
        .padding()
}
