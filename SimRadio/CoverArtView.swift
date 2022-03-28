//
//  CoverArtView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 10.03.2022.
//

import SwiftUI

struct CoverArtView: View {
    let image: UIImage
    let size: CGFloat
    let cornerRadius: CGFloat
    let shadowColor: Color

    init(
        image: UIImage,
        size: CGFloat,
        cornerRadius: CGFloat = 6,
        shadowColor: Color = Color(.systemGray3)
    ) {
        self.image = image
        self.size = size
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(UIColor.systemBackground))
                .frame(width: size, height: size)
                .shadow(color: shadowColor, radius: Constants.shadowRadius)
            Image(uiImage: image)
                .resizable()
                .frame(width: size, height: size)
                .cornerRadius(cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(UIColor.systemGray3), lineWidth: .onePixel))
        }
    }

    enum Constants {
        static let shadowRadius: CGFloat = 20
    }
}

struct CoverArtView_Previews: PreviewProvider {
    static var previews: some View {
        CoverArtView(image: UIImage(named: "gta_v")!, size: 160)
    }
}
