//
//  LibraryViewModel.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 09.03.2022.
//

import Foundation

final class LibraryViewModel: ObservableObject {
    private let library: Library

    var mediaLists: [MediaList] {
        library.mediaLists
    }

    init(library: Library) {
        self.library = library
    }
}
