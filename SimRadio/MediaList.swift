//
//  MediaList.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 08.03.2022.
//

import UIKit

struct MediaList: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let coverArt: UIImage
    var list: [MediaSource]
}
