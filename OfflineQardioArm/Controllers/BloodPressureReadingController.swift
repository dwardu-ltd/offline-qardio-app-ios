//
//  BloodPressureReadingController.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 08/08/2025.
//

import Foundation

class BloodPressureReadingController: NSObject, ObservableObject {
    
    @Published var bloodPressureReadings: [BloodPressureReading] = []
 

}
