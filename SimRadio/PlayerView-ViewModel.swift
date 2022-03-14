//
//  PlayerView-ViewModel.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 08.03.2022.
//

import UIKit

extension PlayerView {
        
    final class ViewModel: ObservableObject {
        
        enum PlayerState {
            case idle
            case playing(source: MediaSource)
            case paused(source: MediaSource)
        }
        
        @Published var state: PlayerState
        @Published var mediaSource: MediaSource
        
        private let mediaList: [MediaSource]
        private var currentMediaIndex: Int
        
        init() {
            currentMediaIndex = 0
            mediaList = Library.makeMock().mediaLists[0].list
            let src = mediaList[currentMediaIndex]
            mediaSource = src
            state = .paused(source: src)
        }
        
        // MARK: Intents
        
        func togglePlay() {
            switch state {
            case .idle:
                playFirst()
            case let .playing(source):
                stop()
                state = .paused(source: source)
            case let .paused(source):
                play(source: source)
                state = .playing(source: source)
            }
        }
        
        func backward() {
            guard !mediaList.isEmpty else { return }
            currentMediaIndex -= 1
            if currentMediaIndex < mediaList.startIndex {
                currentMediaIndex = mediaList.endIndex - 1
            }
            switchToMedia(withIndex: currentMediaIndex)
        }

        func forward() {
            guard !mediaList.isEmpty else { return }
            currentMediaIndex += 1
            if currentMediaIndex >= mediaList.endIndex {
                currentMediaIndex = mediaList.startIndex
            }
            switchToMedia(withIndex: currentMediaIndex)
        }
    }
}

private extension PlayerView.ViewModel {
    
    func switchToMedia(withIndex index: Int) {
        switch state {
        case .idle:
            playFirst()
        case .playing:
            let source = mediaList[index]
            mediaSource = source
            play(source: source)
            state = .playing(source: source)
        case .paused:
            let source = mediaList[index]
            mediaSource = source
            state = .paused(source: source)
        }
    }
    
    func playFirst() {
        guard let source = mediaList.first else { return }
        play(source: source)
        state = .playing(source: source)
    }
        
    func play(source: MediaSource) {
        print("Now playing \(source.title)")
    }

    func stop() {
        print("Playing stopped")
    }

}
