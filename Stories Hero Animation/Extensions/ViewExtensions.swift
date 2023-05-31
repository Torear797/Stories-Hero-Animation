//
//  ViewExtensions.swift
//  Stories Hero Animation
//
//  Created by Torear797 on 31.05.2023.
//

import SwiftUI

extension View {

    @ViewBuilder
    public func `if`<T: View, U: View>(
        _ condition: Bool,
        then modifierT: (Self) -> T,
        else modifierU: (Self) -> U
    ) -> some View {

        if condition { modifierT(self) }
        else { modifierU(self) }
    }
}
