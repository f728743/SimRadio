//
//  Library.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 08.03.2022.
//

import UIKit

struct Library {
    var mediaLists: [MediaList]
}

extension Library {
    static func makeMock() -> Library {
        let mediaLists = [
            [
                ("Los Sant os Rock Radio", "Classic rock, soft rock, pop rock", "radio_01_class_rock", "Kenny Loggins"),
                ("Non-Stop Pop FM", "Pop music, electronic dance music, electro house",
                 "radio_02_pop", "Cara Delevingne"),
                ("Radio Los Santos", "Modern contemporary hip hop, trap", "radio_03_hiphop_new", "Big Boy"),
                ("Channel X", "Punk rock, hardcore punk and grunge", "radio_04_punk", "Keith Morris"),
                ("WCTR: West Coast Talk Radio", "Public Talk Radio", "radio_05_talk_01", nil),
                ("Rebel Radio", "Country music and rockabilly", "radio_06_country", "Jesco White"),
                ("Soulwax FM", "Electronic music", "radio_07_dance_01", "Soulwax"),
                ("East Los FM", "Mexican music and Latin music", "radio_08_mexican", "DJ Camilo and Don Cheto"),
                ("West Coast Classics", "Golden age hip hop and gangsta rap", "radio_09_hiphop_old", "DJ Pooh"),
                ("Blaine County Talk Radio", "Public Talk Radio", "radio_11_talk_02", nil),
                ("Blue Ark", "Reggae, dancehall and dub", "radio_12_reggae", "Lee \"Scratch\" Perry"),
                ("WorldWide FM", "Lounge, chillwave, jazz-funk and world", "radio_13_jazz", "Gilles Peterson"),
                ("FlyLo FM", "IDM and Midwest hip hop", "radio_14_dance_02", "Flying Lotus"),
                ("The Lowdown 91.1", "Classic soul, disco, gospel", "radio_15_motown", "Pam Grier"),
                ("Radio Mirror Park", "Indie pop, synthpop, indietronica and chillwave",
                 "radio_16_silverlake", "Twin Shadow"),
                ("Space 103.2", "Funk and R&B", "radio_17_funk", "Bootsy Collins"),
                ("Vinewood Boulevard Radio", "Garage rock, alternative rock and noise rock",
                 "radio_18_90s_rock", "Nate Williams and Stephen Pope")
            ], [
                ("Rebel Radio", "Country music and rockabilly", "radio_06_country", "Jesco White")
            ], [
                ("Channel X", "Punk rock, hardcore punk and grunge", "radio_04_punk", "Keith Morris")
            ]
        ]

        let mediaListsInfos = [
            ("GTA V", "Rockstar Games", "gta_v"),
            ("Rebel Radio", "GTA V", "radio_06_country"),
            ("Channel X", "GTA V", "radio_04_punk")
        ]

        return Library(
            mediaLists: mediaListsInfos.enumerated().compactMap {
                guard let coverArt = UIImage(named: $1.2) else { return nil }
                return MediaList(
                    id: UUID(),
                    title: $1.0,
                    description: $1.1,
                    coverArt: coverArt,
                    list: mediaLists[$0].compactMap {
                        guard let coverArt = UIImage(named: $0.2) else { return nil }
                        return MediaSource(id: UUID(), title: $0.0, description: $0.1, coverArt: coverArt, live: true)
                    }
                )
            }
        )
    }
}
