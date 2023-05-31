//
//  StaticButtonStyle.swift
//  IOS-Resume
//
//  Created by Torear797 on 22.03.2023.
//

import SwiftUI

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
