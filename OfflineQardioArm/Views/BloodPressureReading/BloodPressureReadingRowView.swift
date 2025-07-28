//
//  BloodPressureReadingRowView.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 26/07/2025.
//

import SwiftUI

struct BloodPressureReadingRowView: View {
    
    let measurementName: String
    let value: String
    let measurementUnit: String
    
    var body: some View {
        HStack {
            Text(measurementName)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
            Text(measurementUnit)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    BloodPressureReadingRowView(measurementName: "Systolic", value: "120", measurementUnit: "mmHg")
}
