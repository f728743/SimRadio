//
//  LibraryView-ViewModel.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 09.03.2022.
//

import Foundation

extension LibraryView {
    final class ViewModel: ObservableObject {
        private let library: Library

        var mediaLists: [MediaList] { // @Published
            library.mediaLists
        }

        init(library: Library) {
            self.library = library
        }
    }
}
