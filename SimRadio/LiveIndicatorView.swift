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
            bar(colors: [Constants.opaque, Constants.transparent])
            Text(Constants.text).font(.title3)
            bar(colors: [Constants.transparent, Constants.opaque])
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
        static let opaque = Color.primary.opacity(0.7)
        static let transparent = Color.primary.opacity(0.1)
        static let barWidth: CGFloat = 4
        static let text = "LIVE"
    }
}

struct LiveIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LiveIndicatorView()
    }
}
