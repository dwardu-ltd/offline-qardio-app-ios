//
//  AverageBloodPressureCoordinator.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 10/08/2025.
//

import Foundation

class AverageBloodPressureCoordinator : ObservableObject {
    
    static let shared: AverageBloodPressureCoordinator = AverageBloodPressureCoordinator()
    
    var maximumReadings: Int8
    @Published var bloodPressureReadings: [BloodPressureReading] = []
    
    
    init(maximumReadings: Int8 = 3) {
        self.maximumReadings = maximumReadings
    }
    
    func averageBloodPressureReadings() -> BloodPressureReading {
        let totalReadings: UInt16 = UInt16(self.bloodPressureReadings.count)
        // Sum up the blood pressure readings
        
        let systolicAverage: UInt16 = self.bloodPressureReadings.map(\.systolic).reduce(0) {(total, number) in return total+number } / totalReadings
        let diastolicAverage: UInt16 = self.bloodPressureReadings.map(\.diastolic).reduce(0) {(total, number) in return total+number } / totalReadings
        let atrialPressureAverage: UInt16 = self.bloodPressureReadings.map(\.atrialPressure).reduce(0) {(total, number) in return total+number } / totalReadings
        let pulseRateAverage: UInt16 = self.bloodPressureReadings.map(\.pulseRate).reduce(0) {(total, number) in return total+number } / totalReadings
        
        
        let averageBloodPressureReadings = BloodPressureReading(systolic: systolicAverage, diastolic: diastolicAverage, atrialPressure: atrialPressureAverage, pulseRate: pulseRateAverage, bloodPressureReadingProgress: .completed)
        
        return averageBloodPressureReadings
    }
    
    func allReadingsCompleted() -> Bool {
        return self.bloodPressureReadings.count == self.maximumReadings
    }
    
}
