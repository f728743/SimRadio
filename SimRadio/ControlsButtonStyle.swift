//
//  ControlsButtonStyle.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 15.03.2022.
//

import SwiftUI

struct ControlsButtonStyle: ButtonStyle {
    let size: CGFloat
    let xOffset: CGFloat
    let fontScale: CGFloat

    init(size: CGFloat, xOffset: CGFloat = 0, fontScale: CGFloat = 0.5) {
        self.size = size
        self.xOffset = xOffset
        self.fontScale = fontScale
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .offset(x: xOffset)
            .frame(width: size, height: size)
            .background(
                configuration.isPressed ? Color.gray.opacity(0.5) : Color.clear
            )
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.linear(duration: 0.35), value: configuration.isPressed)
            .font(.system(size: size * fontScale))
            .contentShape(Rectangle())
    }
}

struct ControlsButton_Previews: PreviewProvider {
    static var previews: some View {
        Button(
            action: {},
            label: {
                Image(systemName: "play.fill")
            }
        )
        .buttonStyle(ControlsButtonStyle(size: 60))
    }
}
