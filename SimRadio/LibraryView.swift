//
//  LibraryView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 02.01.2021.
//

import SwiftUI

struct LibraryView: View {
    @State private var playerShape = PlayerView.Shape.minimized
    @ObservedObject private var viewModel: LibraryViewModel

    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
    }

    private var columns = [
        GridItem(.flexible(), spacing: Constants.padding),
        GridItem(.flexible(), spacing: Constants.padding)
    ]

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: Constants.padding) {
                        ForEach(viewModel.mediaLists, id: \.id) { mediaLists in
                            NavigationLink(destination: MediaListView()) {
                                LibraryItemView(
                                    coverArt: mediaLists.coverArt,
                                    title: mediaLists.title,
                                    description: mediaLists.description,
                                    coverArtSize: Constants.coverArtSize
                                )
                            }
                        }
                    }
                    .padding(Constants.padding)
                }.navigationTitle("Library")
            }
            PlayerView(
                shape: $playerShape,
                viewModel: PlayerViewModel(library: Library.makeMock())
            )
        }.ignoresSafeArea()
    }

    enum Constants {
        static let padding: CGFloat = 20
        static let coverArtSize: CGFloat = (UIScreen.main.bounds.width - padding * 3) / 2
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(viewModel: LibraryViewModel(library: Library.makeMock()))
    }
}
