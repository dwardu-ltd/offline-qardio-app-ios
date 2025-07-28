//
//  BloodPressureReadingView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 26/07/2025.
//
import SwiftUI

struct BloodPressureReadingView: View {
    
    var reading: BloodPressureReading

    var body: some View {
        VStack {
            BloodPressureReadingRowView(
                measurementName: "Systolic",
                value: "\(reading.systolic)",
                measurementUnit: "mmHg"
            ).padding(.horizontal, 20)
            BloodPressureReadingRowView(
                measurementName: "Diastolic",
                value: "\(reading.diastolic)",
                measurementUnit: "mmHg"
            ).padding(.horizontal, 20)
            BloodPressureReadingRowView(
                measurementName: "Atrial Pressure",
                value: "\(reading.atrialPressure)",
                measurementUnit: "mmHg"
            ).padding(.horizontal, 20)
            BloodPressureReadingRowView(
                measurementName: "Pulse Rate",
                value: "\(reading.pulseRate)",
                measurementUnit: "bpm"
            ).padding(.horizontal, 20)
            Divider()
            if (reading.bloodPressureReadingProgress == .failed) {
                Divider()
                Text("There was a problem reading your blood pressure. Please try again.")
            } else  if (reading.bloodPressureReadingProgress == .started) {
                Text("Relax, don't move, measuring your pressure.")
            }
        }
    }
}

#Preview {
    BloodPressureReadingView(reading: BloodPressureReading(systolic: 120, diastolic: 80, atrialPressure: 0, pulseRate: 70, bloodPressureReadingProgress: .notStarted))
}
