//
//  MediaListItemView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 09.03.2022.
//

import SwiftUI

struct MediaListItemView: View {
    let title: String
    let description: String
    let coverArt: Image

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: Constants.textInset) {
                coverArt
                    .resizable()
                    .frame(width: Constants.coverArtSize, height: Constants.coverArtSize)
                    .cornerRadius(Constants.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(Color(UIColor.systemGray3), lineWidth: .onePixel))

                VStack(alignment: .leading, spacing: Constants.textSpacing) {
                    Text(title)
                    Text(description)
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.secondaryLabel))

                }.lineLimit(1)
                Spacer()
            }
            .padding(.vertical, 4)
            .padding(.leading, Constants.coverArtInset)
            Divider().padding(.leading, Constants.separatorInset)
        }
    }

    enum Constants {
        static let coverArtInset: CGFloat = 20
        static let separatorInset: CGFloat = coverArtInset + coverArtSize + textInset
        static let coverArtSize: CGFloat = 48
        static let cornerRadius: CGFloat = 3
        static let textSpacing: CGFloat = 4
        static let textInset: CGFloat = 16
    }
}

struct MediaListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListItemView(
            title: "Los Santos Rock Radio",
            description: "Classic rock, soft rock, pop rock",
            coverArt: Image(uiImage: UIImage(named: "radio_01_class_rock")!)
        )
    }
}
