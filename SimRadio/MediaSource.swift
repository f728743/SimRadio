//
//  MediaSource.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 08.03.2022.
//

import UIKit

struct MediaSource: Identifiable {
    let id: ObjectIdentifier
    let title: String
    let description: String
    let coverArt: UIImage
}
