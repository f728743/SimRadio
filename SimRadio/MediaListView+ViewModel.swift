//
//  MediaListView+ViewModel.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 10.03.2022.
//

import Foundation

extension MediaListView {
    final class ViewModel: ObservableObject {
        @Published var mediaList: MediaList

        init(mediaList: MediaList) {
            self.mediaList = mediaList
        }
    }
}
