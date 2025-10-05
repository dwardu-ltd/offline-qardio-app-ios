//
//  BloodPressureReading.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 25/07/2025.
//
import SwiftUI
import Foundation

struct BloodPressureReading : Identifiable, Hashable {
    var id: UUID = UUID()
    var systolic: UInt16
    var diastolic: UInt16
    var atrialPressure: UInt16
    var pulseRate: UInt16
    var bloodPressureReadingProgress: BloodPressureReadingProgress
    var syncedToHealth: Bool = false
}

extension BloodPressureReading {
    static var examples: [BloodPressureReading] {
        [
            BloodPressureReading(systolic: 120, diastolic: 80, atrialPressure: 90, pulseRate: 65, bloodPressureReadingProgress: .savedToHealthKit),
            BloodPressureReading(systolic: 130, diastolic: 85, atrialPressure: 95, pulseRate: 70, bloodPressureReadingProgress: .savedToHealthKit),
            BloodPressureReading(systolic: 110, diastolic: 75, atrialPressure: 85, pulseRate: 60, bloodPressureReadingProgress: .savedToHealthKit),
            BloodPressureReading(systolic: 140, diastolic: 90, atrialPressure: 100, pulseRate: 75, bloodPressureReadingProgress: .savedToHealthKit),
            BloodPressureReading(systolic: 125, diastolic: 82, atrialPressure: 92, pulseRate: 68, bloodPressureReadingProgress: .savedToHealthKit)
        ]
    }
}

enum BloodPressureReadingProgress {
    case started
    case cancelled
    case completed
    case notStarted
    case failed
    case savedToHealthKit
}
