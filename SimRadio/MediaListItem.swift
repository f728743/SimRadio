//
//  MediaListItem.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 09.03.2022.
//

import SwiftUI

struct MediaListItem: View {
    let station: StationInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: Constants.textInset) {
                Image(station.coverArt)
                    .resizable()
                    .frame(width: Constants.coverArtSize, height: Constants.coverArtSize)
                    .cornerRadius(Constants.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(Color(UIColor.systemGray3), lineWidth: .onePixel))

                VStack(alignment: .leading, spacing: Constants.textSpacing) {
                    Text(station.title)
                    Text(station.dj ?? "")
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

struct MediaListItem_Previews: PreviewProvider {
    static var previews: some View {
        MediaListItem(station:
            StationInfo(
                title: "Los Santos Rock Radio",
                genre: "Classic rock, soft rock, pop rock",
                coverArt: "radio_01_class_rock",
                dj: "Kenny Loggins"
            )
        )
    }
}
