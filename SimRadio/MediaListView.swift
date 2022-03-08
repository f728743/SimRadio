//
//  MediaListView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 04.01.2021.
//

import SwiftUI

struct StationInfo: Identifiable {
    var id = UUID()
    let title: String
    let genre: String
    let coverArt: String
    let dj: String?
}

struct SeriesInfo: Codable {
    let title: String
    let description: String
    let coverArt: String
}

struct MediaListView: View {
    let series = SeriesInfo(title: "GTA V", description: "Rockstar Games", coverArt: "gta_v")
    let stations: [StationInfo] = [
        StationInfo(title: "Los Santos Rock Radio",
                    genre: "Classic rock, soft rock, pop rock",
                    coverArt: "radio_01_class_rock",
                    dj: "Kenny Loggins"),
        StationInfo(title: "Non-Stop Pop FM",
                    genre: "Pop music, electronic dance music, electro house",
                    coverArt: "radio_02_pop",
                    dj: "Cara Delevingne"),
        StationInfo(title: "Radio Los Santos",
                    genre: "Modern contemporary hip hop, trap",
                    coverArt: "radio_03_hiphop_new",
                    dj: "Big Boy"),
        StationInfo(title: "Channel X",
                    genre: "Punk rock, hardcore punk and grunge",
                    coverArt: "radio_04_punk",
                    dj: "Keith Morris"),
        StationInfo(title: "WCTR: West Coast Talk Radio",
                    genre: "Public Talk Radio",
                    coverArt: "radio_05_talk_01",
                    dj: nil),
        StationInfo(title: "Rebel Radio",
                    genre: "Country music and rockabilly",
                    coverArt: "radio_06_country",
                    dj: "Jesco White"),
        StationInfo(title: "Soulwax FM",
                    genre: "Electronic music",
                    coverArt: "radio_07_dance_01",
                    dj: "Soulwax"),
        StationInfo(title: "East Los FM",
                    genre: "Mexican music and Latin music",
                    coverArt: "radio_08_mexican",
                    dj: "DJ Camilo and Don Cheto"),
        StationInfo(title: "West Coast Classics",
                    genre: "Golden age hip hop and gangsta rap",
                    coverArt: "radio_09_hiphop_old",
                    dj: "DJ Pooh"),
        StationInfo(title: "Blaine County Talk Radio",
                    genre: "Public Talk Radio",
                    coverArt: "radio_11_talk_02",
                    dj: nil),
        StationInfo(title: "Blue Ark",
                    genre: "Reggae, dancehall and dub",
                    coverArt: "radio_12_reggae",
                    dj: "Lee \"Scratch\" Perry"),
        StationInfo(title: "WorldWide FM",
                    genre: "Lounge, chillwave, jazz-funk and world",
                    coverArt: "radio_13_jazz",
                    dj: "Gilles Peterson"),
        StationInfo(title: "FlyLo FM",
                    genre: "IDM and Midwest hip hop",
                    coverArt: "radio_14_dance_02",
                    dj: "Flying Lotus"),
        StationInfo(title: "The Lowdown 91.1",
                    genre: "Classic soul, disco, gospel",
                    coverArt: "radio_15_motown",
                    dj: "Pam Grier"),
        StationInfo(title: "Radio Mirror Park",
                    genre: "Indie pop, synthpop, indietronica and chillwave",
                    coverArt: "radio_16_silverlake",
                    dj: "Twin Shadow"),
        StationInfo(title: "Space 103.2",
                    genre: "Funk and R&B",
                    coverArt: "radio_17_funk",
                    dj: "Bootsy Collins"),
        StationInfo(title: "Vinewood Boulevard Radio",
                    genre: "Garage rock, alternative rock and noise rock",
                    coverArt: "radio_18_90s_rock",
                    dj: "Nate Williams and Stephen Pope")
    ]

    var body: some View {
        ScrollView {
            VStack {
                SeriesInfoCell(series: series)
                ForEach(0 ..< stations.count, id: \.self) { index in
                    MediaListItem(station: stations[index]).onTapGesture {
                        print("Tapped!")
                    }
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
    }

    enum Settings {
        static let cellWidth: CGFloat = UIScreen.main.bounds.width
    }
}

struct SeriesInfoCell: View {
    let series: SeriesInfo

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: Settings.cornerRadius)
                    .fill(Color(UIColor.systemBackground))
                    .frame(width: Settings.coverArtSize, height: Settings.coverArtSize)
                    .shadow(color: Color(.systemGray3), radius: 20.0)

                Image(series.coverArt)
                    .resizable()
                    .frame(width: Settings.coverArtSize, height: Settings.coverArtSize)
                    .cornerRadius(Settings.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: Settings.cornerRadius)
                        .stroke(Color(UIColor.systemGray3), lineWidth: .onePixel))

            }.padding()
            Text(series.title).font(.title3).fontWeight(.semibold)
            Text(series.description).font(.title3).foregroundColor(Color(.systemRed))
            Divider().padding(.leading, Settings.separatorInset)
        }
    }

    enum Settings {
        static let coverArtSize: CGFloat = UIScreen.main.bounds.width - 72 * 2
        static let cornerRadius: CGFloat = 6
        static let separatorInset: CGFloat = 20
    }
}
