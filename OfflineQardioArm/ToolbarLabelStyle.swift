//
//  ToolbarLabelStyle.swift
//  OfflineQardioArm
//
//  Created by Edward Vella on 21/09/2025.
//
import Foundation
import SwiftUI

struct ToolbarLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26, *) {
            Label(configuration)
        } else {
            Label(configuration)
                .labelStyle(.titleOnly)
        }
    }
}

@available(iOS, introduced: 18, obsoleted: 26, message: "Remove this property in iOS 26")
extension LabelStyle where Self == ToolbarLabelStyle {
    static var toolbar: Self { .init() }
}
