//
//  LiveIndicatorView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 08.03.2022.
//

import SwiftUI

struct LiveIndicatorView: View {
    var body: some View {
        HStack {
            Capsule()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Settings.opaque, Settings.transparent]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(height: Settings.barWidth)

            Text("LIVE")
                .font(.title3)
                .foregroundColor(.primary)

            Capsule()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Settings.transparent, Settings.opaque]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(height: Settings.barWidth)
        }
    }

    enum Settings {
        static let opaque: Color = Color.primary.opacity(0.7)
        static let transparent: Color = Color.primary.opacity(0.1)
        static let barWidth: CGFloat = 4
    }
}

struct LiveIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LiveIndicatorView()
    }
}
