//
//  PlayerView-ViewModel.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 08.03.2022.
//

import Foundation

extension PlayerView {
    final class ViewModel: ObservableObject {
        private let library: Library

        init(library: Library) {
            self.library = library
        }
    }
}
