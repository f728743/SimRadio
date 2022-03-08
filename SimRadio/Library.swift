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
        Library(
            mediaLists: [
                ("GTA V", "Rockstar Games", "gta_v"),
                ("Rebel Radio", "GTA V", "radio_06_country"),
                ("Channel X", "GTA V", "radio_04_punk")
            ].compactMap {
                guard let coverArt = UIImage(named: $0.2) else { return nil }
                return MediaList(
                    id: UUID(),
                    title: $0.0,
                    description: $0.1,
                    coverArt: coverArt,
                    list: []
                )
            }
        )
    }
}
