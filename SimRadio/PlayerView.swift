//
//  PlayerView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 08.01.2021.
//

import ColorKit
import SwiftUI

struct PlayerView: View {
    enum Shape {
        case maximized
        case minimized
    }

    @State private var shape: Shape
    @State private var volume: Double = 0
    @State private var offset: CGFloat = 0
    @StateObject private var viewModel: ViewModel
    @State private var gradietnModel = AnimatedGradient.Model(colors: [])
    init(shape: Shape = .minimized) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        _shape = State(initialValue: shape)
    }

    // MARK: body

    var body: some View {
        ZStack(alignment: .top) {
            background
                .onTapGesture { maximize() }
                .cornerRadius(cornerRadius)
                .frame(maxHeight: isMaximized ? .infinity : Constants.Minimized.height)

            VStack {
                grip
                Spacer()
                coverArt
                Spacer()
                VStack {
                    Spacer()
                    VStack {
                        trackInfo
                        LiveIndicatorView(color: Constants.controlsPrimary)
                    }
                    Spacer()
                    playerControls
                    Spacer()
                    VStack(spacing: 16) {
                        volumeControl
                        airplayButton
                    }
                }
                .padding(.horizontal, Constants.Maximized.horizontalPadding)
                .padding(.top, isMinimized ? screenSize.height : 0) // pushes out maximized player
                .frame(maxHeight: isMinimized ? 0 : .infinity)
            }
            .foregroundColor(Constants.controlsPrimary)
            .frame(maxHeight: isMaximized ? .infinity : Constants.Minimized.height)

            miniPlayer
        }
        .offset(y: offset)
        .ignoresSafeArea()
        .gesture(
            DragGesture().onEnded(handleDragEnd(value:)).onChanged(handleDragChange(value:))
        )
        .onChange(of: viewModel.mediaSource.coverArt) { _ in
            updateColors(animation: true)
        }
        .onAppear {
            updateColors(animation: false)
        }
    }
}

private extension PlayerView {
    // MARK: Background

    var background: some View {
        ZStack {
            GradientEffectView($gradietnModel)
                .opacity(isMaximized ? 1 : 0)
                .transition(.identity)
            BlurView()
                .opacity(isMaximized ? 0 : 1)
        }
    }

    // MARK: Grip

    var grip: some View {
        Capsule()
            .fill(Constants.controlsTetiary)
            .frame(width: Constants.gripWidth, height: isMaximized ? Constants.gripHeight : 0)
            .padding(.top, isMaximized ? safeArea?.top : 0)
    }

    // MARK: Cover Art

    var coverArt: some View {
        let paddingK = Constants.Maximized.CoverArt.topPaddingK
        let paddingB = Constants.Maximized.CoverArt.topPaddingB
        return HStack {
            if isMaximized { Spacer() }
            CoverArtView(
                image: viewModel.mediaSource.coverArt,
                size: coverArtSize - coverArtPlayStopIndent * 2,
                cornerRadius: coverArtCornerRadius,
                shadowColor: isMaximized ?
                    Constants.Maximized.CoverArt.shadowColor : Constants.Minimized.CoverArt.shadowColor
            )
            .frame(width: coverArtSize, height: coverArtSize)
            .padding(.left, isMinimized ? Constants.Minimized.horizontalPadding : 0)
            Spacer()
        }
        .padding(.top, isMaximized ? max(paddingK * screenSize.height - paddingB, 0) : 0)
    }

    // MARK: Maximized player track info

    var trackInfo: some View {
        VStack(spacing: 4) {
            HStack { Spacer() }
            let fade = Constants.Maximized.titleFadeLength
            MarqueeText(
                text: viewModel.mediaSource.title,
                font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3).bold(),
                leftFade: fade,
                rightFade: fade,
                startDelay: Constants.marqueeTextStartDelay
            )
            MarqueeText(
                text: viewModel.mediaSource.description,
                font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3),
                leftFade: fade,
                rightFade: fade,
                startDelay: Constants.marqueeTextStartDelay
            )
            .foregroundColor(Constants.controlsSecondary)
        }
        .id(viewModel.mediaSource.id)
        .transition(.identity)
    }

    // MARK: Maximized player controls

    var playerControls: some View {
        HStack(spacing: Constants.Maximized.Buttons.spacing) {
            Button(action: backward) { Image(systemName: Constants.backwardButtonImage) }
                .disabled(!viewModel.isSwitchSourceEnabled)
                .buttonStyle(ControlsButtonStyle(size: Constants.Maximized.Buttons.switchSize))
            Button(action: togglePlay) { playToggleButtonImage }
                .disabled(!viewModel.isPlayingEnabled)
                .buttonStyle(
                    ControlsButtonStyle(
                        size: Constants.Maximized.Buttons.playSize,
                        xOffset: playToggleButtonOffset,
                        fontScale: Constants.Maximized.Buttons.playImageScale
                    )
                )
            Button(action: forward) { Image(systemName: Constants.forwardButtonImage) }
                .disabled(!viewModel.isSwitchSourceEnabled)
                .buttonStyle(ControlsButtonStyle(size: Constants.Maximized.Buttons.switchSize))
        }
        .font(.largeTitle)
        .accentColor(.primary)
    }

    // MARK: Volume control

    var volumeControl: some View {
        HStack(spacing: 15) {
            Image(systemName: Constants.lowVolumeImage)
            SwiftUISlider(
                thumbColor: Constants.controlsPrimary,
                minTrackColor: Constants.controlsSecondary,
                maxTrackColor: Constants.controlsTetiary,
                value: $volume
            )
            Image(systemName: Constants.highVolumeImage)
        }
        .imageScale(.small)
        .foregroundColor(Constants.controlsSecondary)
    }

    var airplayButton: some View {
        Button(action: airplay) {
            Image(systemName: Constants.airplayImage).font(.title2)
        }
        .foregroundColor(Constants.controlsSecondary)
        .padding(.bottom, safeArea?.bottom == 0 ? Constants.airplayBottomPadding : safeArea?.bottom)
    }

    // MARK: Mini Player

    var miniPlayer: some View {
        HStack {
            Text(viewModel.mediaSource.title)
                .id(viewModel.mediaSource.id)
                .transition(.identity)
                .lineLimit(1)
                .padding(.left, Constants.Minimized.titlePadding)
            Spacer(minLength: Constants.Minimized.Buttons.spacing)
            HStack(spacing: Constants.Minimized.Buttons.spacing) {
                Button(action: togglePlay) { playToggleButtonImage }
                    .disabled(!viewModel.isPlayingEnabled)
                    .buttonStyle(
                        ControlsButtonStyle(
                            size: Constants.Minimized.Buttons.size,
                            xOffset: playToggleButtonOffset
                        )
                    )
                Button(action: forward) { Image(systemName: Constants.forwardButtonImage) }
                    .disabled(!viewModel.isSwitchSourceEnabled)
                    .buttonStyle(ControlsButtonStyle(size: Constants.Minimized.Buttons.size))
            }
            .font(.title2)
            .accentColor(.primary)
        }
        .padding(.horizontal, Constants.Minimized.horizontalPadding)
        .opacity(isMinimized ? 1 : 0)
        .frame(height: Constants.Minimized.height)
    }

    // MARK: Computed params

    var safeArea: UIEdgeInsets? {
        let window = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        return window?.safeAreaInsets
    }

    var screenSize: CGSize { UIScreen.main.bounds.size }

    var playToggleButtonImage: Image {
        switch viewModel.playToggleButtonState {
        case .play: return Image(systemName: Constants.playButtonImage)
        case .stop: return Image(systemName: Constants.stopButtonImage)
        case .pause: return Image(systemName: Constants.pauseButtonImage)
        }
    }

    var playToggleButtonOffset: CGFloat {
        if viewModel.playToggleButtonState == .play, viewModel.mediaSource.isLive {
            return isMaximized ?
                Constants.Maximized.Buttons.playImageOffset :
                Constants.Minimized.Buttons.playImageOffset
        }
        return 0
    }

    var coverArtPlayStopIndent: CGFloat {
        isMaximized && viewModel.playToggleButtonState == .play ? screenSize.width / 8.4 : 0
    }

    var cornerRadius: CGFloat {
        isMaximized ? Constants.Maximized.cornerRadius : Constants.Minimized.cornerRadius
    }

    var coverArtSize: CGFloat {
        isMaximized ?
            screenSize.width - Constants.Maximized.CoverArt.horizontalPadding * 2 :
            Constants.Minimized.CoverArt.size
    }

    var coverArtCornerRadius: CGFloat {
        isMaximized ?
            Constants.Maximized.CoverArt.cornerRadius : Constants.Minimized.CoverArt.cornerRadius
    }

    var isMinimized: Bool { shape == .minimized }

    var isMaximized: Bool { shape == .maximized }

    func maximize() {
        guard isMinimized else { return }
        withAnimation(.spring()) { shape = .maximized }
    }

    func handleDragChange(value: DragGesture.Value) {
        guard isMaximized else { return }
        if value.translation.height > 0 {
            offset = value.translation.height
        }
    }

    func handleDragEnd(value: DragGesture.Value) {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)) {
            if value.translation.height > 80 {
                shape = .minimized
            }
            offset = 0
        }
    }

    func updateColors(animation: Bool) {
        let coverArt = viewModel
            .mediaSource
            .coverArt
            .convertToRGBColorspace() ?? UIImage()
        guard let dominantColors = try? coverArt.dominantColorFrequencies(with: .high) else { return }

        // hack: if we have NavigationView in MediaListView, somehow content of MediaListView
        // appears with weird animation of this speed despite of any .transition(.identity)
        // even if there is no GradientEffectView in background
        withAnimation(.linear.speed(animation ? 0.5 : 10000)) {
            gradietnModel.colors = dominantColors.prefix(5).map { Color(uiColor: $0.color) }
        }
    }

    // MARK: Actions

    func togglePlay() {
        withAnimation { viewModel.togglePlay() }
    }

    func backward() {
        withAnimation { viewModel.backward() }
    }

    func forward() {
        withAnimation { viewModel.forward() }
    }

    func airplay() {
        print("airplay pressed")
    }

    // MARK: Constants

    // swiftlint:disable file_length
    // swiftlint:disable nesting
    enum Constants {
        enum Maximized {
            enum Buttons {
                static let spacing: CGFloat = 28
                static let playImageOffset: CGFloat = -4
                static let playImageScale: CGFloat = 0.6
                static let playSize: CGFloat = 80
                static let switchSize: CGFloat = 70
            }

            enum CoverArt {
                static let topPaddingK: CGFloat = 0.16
                static let topPaddingB: CGFloat = 100
                static let horizontalPadding: CGFloat = 24
                static let cornerRadius: CGFloat = 9
                static let shadowColor: Color = .black.opacity(0.5)
            }

            static let spacing: CGFloat = 8
            static let horizontalPadding: CGFloat = 32
            static let titleFadeLength: CGFloat = 24
            static let cornerRadius: CGFloat = 20
        }

        enum Minimized {
            enum Buttons {
                static let spacing: CGFloat = 2
                static let playImageOffset: CGFloat = -2
                static let size: CGFloat = 50
            }

            enum CoverArt {
                static let size: CGFloat = 48
                static let cornerRadius: CGFloat = 3
                static let shadowColor: Color = .init(uiColor: .systemGray3)
            }

            static let height: CGFloat = 80
            static let horizontalPadding: CGFloat = 20
            static let titlePadding: CGFloat = 64
            static let cornerRadius: CGFloat = 0
        }

        static let gripWidth: CGFloat = 36
        static let gripHeight: CGFloat = 5

        static let airplayBottomPadding: CGFloat = 16
        static let controlsPrimary = Color.white
        static let controlsSecondary = controlsPrimary.opacity(0.6)
        static let controlsTetiary = controlsPrimary.opacity(0.3)

        static let marqueeTextStartDelay: Double = 3

        static let backwardButtonImage = "backward.fill"
        static let forwardButtonImage = "forward.fill"
        static let playButtonImage = "play.fill"
        static let stopButtonImage = "stop.fill"
        static let pauseButtonImage = "pause.fill"
        static let lowVolumeImage = "speaker.fill"
        static let highVolumeImage = "speaker.wave.3.fill"
        static let airplayImage = "airplayaudio"
    }
}

struct PlayerView_Previews: PreviewProvider {
    @State static var playerShape = PlayerView.Shape.maximized
    static var previews: some View {
        PlayerView()
    }
}
