//
//  AverageBloodPressureCoordinator.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 10/08/2025.
//

import Foundation

class AverageBloodPressureCoordinator : NSObject, ObservableObject {
    
    static let shared: AverageBloodPressureCoordinator = AverageBloodPressureCoordinator(maximumReadings: 3)
    
    var maximumReadings: Int8
    @Published var bloodPressureReadings: [BloodPressureReading]
    
    var hasReadings: Bool {
        return !self.bloodPressureReadings.isEmpty
    }
    
    var isCompleted: Bool {
        return self.bloodPressureReadings.count == self.maximumReadings
    }
    
    init(maximumReadings: Int8 = 3, bloodPressureReadings: [BloodPressureReading] = []) {
        self.maximumReadings = maximumReadings
        self.bloodPressureReadings = bloodPressureReadings
    }
    
    func reset() {
        self.bloodPressureReadings = []
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


extension AverageBloodPressureCoordinator {
    
    static func controllerWithSampleData(currentReadings: Int8, maximumReadings: Int8) -> AverageBloodPressureCoordinator {
        var bloodPressureReadings: [BloodPressureReading] = []
        let examplesCount = BloodPressureReading.examples.count
        for _ in 0..<currentReadings {
          // Get a random item from the examples of BloodPressureReading
            let randomIndex = Int.random(in: 0..<examplesCount)
            bloodPressureReadings.append(BloodPressureReading.examples[randomIndex])
        }
        
        let averageBloodPressureCoordinator = AverageBloodPressureCoordinator(maximumReadings: maximumReadings, bloodPressureReadings:bloodPressureReadings)
        
        return averageBloodPressureCoordinator
    }
}
