//
//  LiveIndicatorView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 08.03.2022.
//

import SwiftUI

struct LiveIndicatorView: View {
    let color: Color

    var body: some View {
        HStack {
            bar(colors: [color.opacity(0.7), color.opacity(0.1)])
            Text(Constants.text).font(.title3)
            bar(colors: [color.opacity(0.1), color.opacity(0.7)])
        }
    }

    func bar(colors: [Color]) -> some View {
        Capsule()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .leading, endPoint: .trailing
                )
            ).frame(height: Constants.barWidth)
    }

    enum Constants {
        static let barWidth: CGFloat = 4
        static let text = "LIVE"
    }
}

struct LiveIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LiveIndicatorView(color: .primary)
    }
}
