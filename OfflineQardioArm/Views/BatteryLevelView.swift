//
//  BatteryLevelView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 28/07/2025.
//
import SwiftUI

struct BatteryLevelView: View {
    
    let batteryLevel: UInt8
    private let batteryRotation: Double = 180
    
    var body: some View {
        if (batteryLevel > 90) {
            Image(systemName:"battery.100percent")
                .foregroundStyle(.green)
                .rotationEffect(.degrees(batteryRotation))
        } else if (batteryLevel > 75) {
            Image(systemName:"battery.75percent")
                .foregroundStyle(.green)
                .rotationEffect(.degrees(batteryRotation))
        } else if (batteryLevel > 50) {
            Image(systemName:"battery.50percent")
                .foregroundStyle(.orange)
                .rotationEffect(.degrees(batteryRotation))
        } else if (batteryLevel > 25) {
            Image(systemName:"battery.25percent")
                .foregroundStyle(.orange)
                .rotationEffect(.degrees(batteryRotation))
        } else {
            Image(systemName:"battery.0percent")
                .foregroundStyle(.red)
                .rotationEffect(.degrees(batteryRotation))
        }
    }
}

#Preview {
    HStack {
        BatteryLevelView(batteryLevel: 100)
        BatteryLevelView(batteryLevel: 85)
        BatteryLevelView(batteryLevel: 65)
        BatteryLevelView(batteryLevel: 35)
        BatteryLevelView(batteryLevel: 10)
    }
}
