//
//  LibraryItemView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 09.03.2022.
//

import SwiftUI

struct LibraryItemView: View {
    let coverArt: UIImage
    let title: String
    let description: String
    let coverArtSize: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: coverArt)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: coverArtSize, height: coverArtSize)
                .cornerRadius(Settings.cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: Settings.cornerRadius)
                    .stroke(Color(UIColor.systemGray3), lineWidth: .onePixel))
            Text(title).foregroundColor(Color(UIColor.label))
            Text(description).foregroundColor(Color(UIColor.secondaryLabel))
        }.font(.subheadline)
    }

    enum Settings {
        static let cornerRadius: CGFloat = 4
    }
}

struct LibraryItemView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryItemView(
            coverArt: UIImage(named: "gta_v")!,
            title: "GTA V",
            description: "Rockstar Games",
            coverArtSize: 160
        )
    }
}
