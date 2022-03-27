//
//  LibraryView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 02.01.2021.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
                            NavigationLink(
                                destination: MediaListView(
                                    viewModel: MediaListView.ViewModel(mediaList: mediaLists)
                                )
                            ) {
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
                }
                .navigationTitle("Library")
            }
            .navigationViewStyle(.stack)
            PlayerView()
        }
        .ignoresSafeArea()
    }

    enum Constants {
        static let padding: CGFloat = 20
        static let coverArtSize: CGFloat = (UIScreen.main.bounds.width - padding * 3) / 2
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(viewModel: LibraryView.ViewModel(library: Library.makeMock()))
    }
}
