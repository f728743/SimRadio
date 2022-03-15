//
//  ControlsButton.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 15.03.2022.
//

import SwiftUI

struct ControlsButton: View {
    let action: () -> Void
    let isDisabled: Bool

    var body: some View {
        Button(
            action: {
                withAnimation {
                    self.action()
                    self.clickCount += 1
                }
            },
            label: {
                Image(systemName: "arrow.up.circle")
                    .rotationEffect(.radians(2 * Double.pi * clickCount))
                    .animation(.easeOut, value: clickCount)
            }
        )
        .disabled(isDisabled)
    }

    @State private var clickCount: Double = 0
}

struct ControlsButton_Previews: PreviewProvider {
    static var previews: some View {
        ControlsButton(action: {}, isDisabled: false)
    }
}
