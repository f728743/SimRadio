//
//  CoverArtView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 10.03.2022.
//

import SwiftUI

struct CoverArtView: View {
    let coverArt: UIImage
    let coverArtSize: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color(UIColor.systemBackground))
                .frame(width: coverArtSize, height: coverArtSize)
                .shadow(color: Color(.systemGray3), radius: Constants.shadowRadius)
            Image(uiImage: coverArt)
                .resizable()
                .frame(width: coverArtSize, height: coverArtSize)
                .cornerRadius(Constants.cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(Color(UIColor.systemGray3), lineWidth: .onePixel))
        }.padding()
    }

    enum Constants {
        static let cornerRadius: CGFloat = 6
        static let shadowRadius: CGFloat = 20
    }
}

struct CoverArtView_Previews: PreviewProvider {
    static var previews: some View {
        CoverArtView(coverArt: UIImage(named: "gta_v")!, coverArtSize: 160)
    }
}
