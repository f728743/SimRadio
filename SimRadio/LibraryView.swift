//
//  LibraryView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 02.01.2021.
//

import SwiftUI

struct SeriesInfo: Codable {
    let title: String
    let description: String
    let coverArt: String
}

struct LibraryView: View {
    private var columns = Array(repeating: GridItem(.flexible(), spacing: Settings.padding), count: 2)

    let series = [
        SeriesInfo(title: "GTA V", description: "Rockstar Games", coverArt: "gta_v"),
        SeriesInfo(title: "Rebel Radio (GTA V)", description: "Rockstar Games", coverArt: "radio_06_country"),
        SeriesInfo(title: "Channel X (GTA V)", description: "Rockstar Games", coverArt: "radio_04_punk")
    ]
    
    let stations = ["radio_01_class_rock", "radio_02_pop", "radio_03_hiphop_new", "radio_04_punk",
                    "radio_05_talk_01", "radio_06_country", "radio_07_dance_01", "radio_08_mexican",
                    "radio_09_hiphop_old", "radio_11_talk_02", "radio_12_reggae", "radio_13_jazz",
                    "radio_14_dance_02", "radio_15_motown", "radio_16_silverlake", "radio_17_funk"]

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
        NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: Settings.padding) {
                        ForEach(0 ..< series.count, id: \.self) { index in
                            NavigationLink(destination: SeriesView()) {
                                VStack(alignment: .leading) {
                                    Image(series[index].coverArt)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: Settings.coverArtSize, height: Settings.coverArtSize)
                                        .cornerRadius(Settings.cornerRadius)
                                        .overlay(RoundedRectangle(cornerRadius: Settings.cornerRadius)
                                                    .stroke(Color(UIColor.systemGray3), lineWidth: .onePixel))
                                    Text(series[index].title).foregroundColor(Color(UIColor.label))
                                    Text(series[index].description).foregroundColor(Color(UIColor.secondaryLabel))
                                }.font(.subheadline)
                            }
                        }
                    }
                    .padding(Settings.padding)
                }.navigationTitle("Library")
                
            }
        }
    }

    enum Settings {
        static let padding: CGFloat = 20
        static let coverArtSize: CGFloat = (UIScreen.main.bounds.width - padding * 3) / 2
        static let cornerRadius: CGFloat = 4
    }
}
