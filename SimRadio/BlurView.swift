//
//  BlurView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 05.01.2021.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))

        return view
    }

    func updateUIView(_: UIVisualEffectView, context _: Context) {}
}
