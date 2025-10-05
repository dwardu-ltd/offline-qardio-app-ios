//
//  HealthKitController.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 26/07/2025.
//

import HealthKit
import Foundation

class HealthKitController : ObservableObject {
    static let shared: HealthKitController = HealthKitController()
    
    static let healthStore = HKHealthStore()
    // Define the types of data you want to read or write.
    
    @Published var healthDataAvailable: Bool = HKHealthStore.isHealthDataAvailable()
    @Published var healthDataAuthorized: Bool = false
    @Published var guestReading: Bool = false
    static let allTypes: Set = [
        HKQuantityType(.bloodPressureSystolic),
        HKQuantityType(.bloodPressureDiastolic),
        HKQuantityType(.heartRate)
    ]
    
    init() {
        self.healthDataAuthorized = self.isAuthorized()
    }
    
    func saveBloodPressureReading(reading: BloodPressureReading) -> Bool {
        if (self.guestReading) {
         print("Guest Reading, Ignoring...")
            self.guestReading = false
            return true
        }
        if (reading.bloodPressureReadingProgress != .completed) {
            print("Reading Incomplete")
            print("Reading Progress: \(reading.bloodPressureReadingProgress)")
            return false
        }
        // Save the blood pressure reading to HealthKit.
        guard healthDataAuthorized else {
            print("Health data not authorized")
            return false
        }
        //        if !reading.syncedToHealth {
        let date = Date()
        let systolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let diastolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let systolicQuantity = HKQuantity(unit: HKUnit.millimeterOfMercury(), doubleValue: Double(reading.systolic))
        let diastolicQuantity = HKQuantity(unit: HKUnit.millimeterOfMercury(), doubleValue: Double(reading.diastolic))
        let heartRateQuantity = HKQuantity(unit: HKUnit.count().unitDivided(by: HKUnit.minute()), doubleValue: Double(reading.pulseRate))
        let systolicSample = HKQuantitySample(type: systolicType, quantity: systolicQuantity, start: date, end: date)
        let diastolicSample = HKQuantitySample(type: diastolicType, quantity: diastolicQuantity, start: date, end: date)
        let heartRateSample = HKQuantitySample(type: heartRateType, quantity: heartRateQuantity, start: date, end: date)
        
        // Create blood pressure sample
        
        guard let bloodPressureType = HKObjectType.correlationType(forIdentifier: .bloodPressure) else {
            fatalError("*** Unable to create the blood pressure type ***")
        }
        
        let objects: Set = [systolicSample, diastolicSample]
        
        let bloodpressure = HKCorrelation(type: bloodPressureType,
                                          start: date, end: date, objects:objects)
        
        let healthStore = HealthKitController.healthStore
        
        var result: Bool = false
        healthStore.save([bloodpressure, heartRateSample]) { (success, error) in
            if let error = error {
                print("Error saving blood pressure reading: \(error.localizedDescription)")
            } else {
                print("Blood pressure reading saved successfully")
            }
            
            result = success
        }
        return result
        //        }
        //        return true
    }
    
    func isAuthorized() -> Bool {
        // Check if the user has granted permission to access HealthKit data.
        
        // If the request is successful, update the healthDataAuthorized property.
        self.healthDataAuthorized = HealthKitController.healthStore.authorizationStatus(for: HKQuantityType(.bloodPressureDiastolic)) == .sharingAuthorized &&
                HealthKitController.healthStore.authorizationStatus(for: HKQuantityType(.bloodPressureSystolic)) == .sharingAuthorized &&
                HealthKitController.healthStore.authorizationStatus(for: HKQuantityType(.heartRate)) == .sharingAuthorized
        return self.healthDataAuthorized
        
    }
    
    func requestAuthorization() async throws {
        do {
            // Check that Health data is available on the device.
            if HKHealthStore.isHealthDataAvailable() {
                
                // Asynchronously request authorization to the data.
                try await HealthKitController.healthStore.requestAuthorization(toShare: HealthKitController.allTypes, read: [])
                
            }
        } catch {
            
            // Typically, authorization requests only fail if you haven't set the
            // usage and share descriptions in your app's Info.plist, or if
            // Health data isn't available on the current device.
            fatalError("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
        }
    }
}
