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

enum BloodPressureReadingProgress {
    case started
    case cancelled
    case completed
    case notStarted
    case failed
    case savedToHealthKit
}
