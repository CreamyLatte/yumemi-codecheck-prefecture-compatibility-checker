//
//  CapsuleButtonStyle.swift
//  PrefectureCompatibilityChecker
//
//  Created by Eisuke KASAHARA on 2023/05/23.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .bold()
            .frame(maxWidth: 400)
            .padding()
            .background((self.isEnabled ? Color.green : Color.gray).opacity(configuration.isPressed ? 0.9 : 1.0))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.975 : 1.0)
    }
}
