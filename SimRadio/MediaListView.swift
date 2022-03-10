//
//  MediaListView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 04.01.2021.
//

import SwiftUI

struct MediaListView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack {
                CoverArtView(coverArt: viewModel.mediaList.coverArt, coverArtSize: Constants.coverArtSize)
                Text(viewModel.mediaList.title).font(.title3).fontWeight(.semibold)
                Text(viewModel.mediaList.description).font(.title3).foregroundColor(Color(.systemRed))
                Divider().padding(.leading, Constants.separatorInset)
                ForEach(viewModel.mediaList.list, id: \.id) { mediaSource in
                    MediaListItemView(
                        title: mediaSource.title,
                        description: mediaSource.description,
                        coverArt: Image(uiImage: mediaSource.coverArt)
                    ).onTapGesture {
                        print("will play '\(mediaSource.title)'")
                    }
                }
            }
        }.navigationBarTitle("", displayMode: .inline)
    }

    enum Constants {
        static let cellWidth: CGFloat = UIScreen.main.bounds.width
        static let separatorInset: CGFloat = 20
        static let coverArtSize: CGFloat = UIScreen.main.bounds.width - 72 * 2
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListView(
            viewModel: MediaListView.ViewModel(
                mediaList: Library.makeMock().mediaLists[0]
            )
        )
    }
}
