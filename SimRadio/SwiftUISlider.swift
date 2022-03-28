//
//  SwiftUISlider.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 28.03.2022.
//

import SwiftUI

struct SwiftUISlider: UIViewRepresentable {
    final class Coordinator: NSObject {
        // The class property value is a binding: It’s a reference to the SwiftUISlider
        // value, which receives a reference to a @State variable value in ContentView.
        var value: Binding<Double>

        // Create the binding when you initialize the Coordinator
        init(value: Binding<Double>) {
            self.value = value
        }

        // Create a valueChanged(_:) action
        @objc func valueChanged(_ sender: UISlider) {
            value.wrappedValue = Double(sender.value)
        }
    }

    var thumbColor: Color = .white
    var minTrackColor: Color?
    var maxTrackColor: Color?

    @Binding var value: Double

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.thumbTintColor = UIColor(thumbColor)
        slider.minimumTrackTintColor = minTrackColor.map { UIColor($0) }
        slider.maximumTrackTintColor = maxTrackColor.map { UIColor($0) }
        slider.value = Float(value)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return slider
    }

    func updateUIView(_ uiView: UISlider, context _: Context) {
        // Coordinating data between UIView and SwiftUI view
        uiView.value = Float(value)
    }

    func makeCoordinator() -> SwiftUISlider.Coordinator {
        Coordinator(value: $value)
    }
}

struct SwiftUISlider_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISlider(
            thumbColor: .red,
            minTrackColor: .blue,
            maxTrackColor: .green,
            value: .constant(0.5)
        )
    }
}
