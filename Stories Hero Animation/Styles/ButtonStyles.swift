//
//  ButtonStyles.swift
//  IOS-Resume
//
//  Created by Torear797 on 21.12.2022.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeOut, value: configuration.isPressed)
    }
}
