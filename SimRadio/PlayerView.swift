//
//  PlayerView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 08.01.2021.
//

import SwiftUI

struct PlayerView: View {
    enum Shape {
        case maximized
        case minimized
    }

    @Binding private var shape: Shape
    @State private var volume: CGFloat = 0
    @State private var offset: CGFloat = 0
    private var safeArea = UIApplication.shared.windows.first?.safeAreaInsets

    @StateObject private var viewModel: ViewModel

    init(shape: Binding<Shape>) {
        _shape = shape
        _viewModel = StateObject(wrappedValue: ViewModel())
    }

    var body: some View {
        ZStack(alignment: .top) {            
            BlurView()
                .onTapGesture { maximize() }
                .cornerRadius(cornerRadius)
                .frame(maxHeight: shape == .maximized ? .infinity : Constants.minimizedHeight)

            VStack(spacing: 0) {
                if isMinimized { Spacer() }
                grip
                Color(.red).opacity(0.05).frame(maxHeight: isMinimized ? 0 : 50)
                coverArt
                Spacer()
                VStack {
                    trackInfo
                    LiveIndicatorView().padding()
                    playerControls
                    volumeControl
                    airplayButton
                    Spacer()
                }
                .padding(.top, isMinimized ? 600 : 0)
                .frame(maxHeight: isMinimized ? 0 : 600)
                .background(Color(.green).opacity(0.05))
            }
            .frame(maxHeight: shape == .maximized ? .infinity : Constants.minimizedHeight)
            
            miniPlayer
        }

//        .offset(y: -Constants.bottomInset(for: shape))
        .offset(y: offset)
        .gesture(DragGesture().onEnded(handleDragEnd(value:)).onChanged(handleDragChange(value:)))
        .ignoresSafeArea()
    }

    var trackInfo: some View {
        VStack {
            Text(viewModel.mediaSource.title)
            Text(viewModel.mediaSource.description)
        }
//        .padding(.top, 20)
    }

    var playToggleButtonImage: Image {
        switch viewModel.playToggleButtonState {
        case .play: return Image(systemName: Constants.playButtonImage)
        case .stop: return Image(systemName: Constants.stopButtonImage)
        case .pause: return Image(systemName: Constants.playButtonImage)
        }
    }

    var playToggleButtonOffset: CGFloat {
        if viewModel.playToggleButtonState == .play {
            return shape == .maximized ?
            Constants.Maximized.Buttons.playImageOffset :
            Constants.Minimized.Buttons.playImageOffset
        }
        return 0
    }

    var playerControls: some View {
        HStack(spacing: Constants.Maximized.Buttons.spacing) {
            Button(action: backward) { Image(systemName: Constants.backwardButtonImage) }
                .disabled(!viewModel.isSwitchSourceEnabled)
                .buttonStyle(ControlsButtonStyle(size: Constants.Maximized.Buttons.switchButtonSize))
            Button(action: togglePlay) { playToggleButtonImage }
                .disabled(!viewModel.isPlayingEnabled)
                .buttonStyle(
                    ControlsButtonStyle(
                        size: Constants.Maximized.Buttons.playButtonSize,
                        xOffset: playToggleButtonOffset,
                        fontScale: Constants.Maximized.Buttons.playImageScale
                    )
                )
            Button(action: forward) { Image(systemName: Constants.forwardButtonImage) }
                .disabled(!viewModel.isSwitchSourceEnabled)
                .buttonStyle(ControlsButtonStyle(size: Constants.Maximized.Buttons.switchButtonSize))
        }
        .font(.largeTitle)
        .accentColor(.primary)
        .padding()
    }

    var volumeControl: some View {
        HStack(spacing: 15) {
            Image(systemName: "speaker.fill")
            Slider(value: $volume)
            Image(systemName: "speaker.wave.2.fill")
        }
        .padding()
    }

    var airplayButton: some View {
        Button(action: airplay) {
            Image(systemName: "airplayaudio")
                .font(.title2)
                .foregroundColor(.primary)
        }
        .padding()
//        .padding(.bottom, safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
    }

    var miniPlayer: some View {
        ZStack {
            //                Color(.yellow).opacity(0.3).onTapGesture {
            //                    withAnimation(.spring()) { shape = .expanded }
            //                }
            HStack {
                Text(viewModel.mediaSource.title).padding(.leading, Constants.maximizedTitlePadding)
                Spacer(minLength: 0)
                HStack(spacing: Constants.Minimized.Buttons.spacing) {
                    Button(action: togglePlay) { playToggleButtonImage }
                        .disabled(!viewModel.isPlayingEnabled)
                        .buttonStyle(
                            ControlsButtonStyle(
                                size: Constants.Minimized.Buttons.buttonSize,
                                xOffset: playToggleButtonOffset
                            )
                        )
                    Button(action: forward) { Image(systemName: Constants.forwardButtonImage) }
                        .disabled(!viewModel.isSwitchSourceEnabled)
                        .buttonStyle(ControlsButtonStyle(size: Constants.Minimized.Buttons.buttonSize))
                }
                .font(.title2)
                .accentColor(.primary)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .opacity(shape == .minimized ? 1 : 0)
        }.frame(height: Constants.minimizedHeight)
    }

    var coverArt: some View {
        HStack {
            if shape == .maximized { Spacer(minLength: 0) }

            ZStack {
                RoundedRectangle(cornerRadius: coverArtCornerRadius)
                    .fill(Color(UIColor.systemBackground))
                    .frame(width: coverArtSize, height: coverArtSize)
                    .shadow(color: Color(.systemGray3), radius: 20.0)
                Image(uiImage: viewModel.mediaSource.coverArt)
                    .resizable()
                    .frame(width: coverArtSize, height: coverArtSize)
                    .cornerRadius(coverArtCornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: coverArtCornerRadius)
                        .stroke(Color(UIColor.systemGray3), lineWidth: .onePixel))
            }
            Spacer(minLength: 0)
        }
    }
}

private extension PlayerView {
    var isMinimized: Bool { shape == .minimized }

    func maximize() {
        guard shape == .minimized else { return }
        withAnimation(.spring()) { shape = .maximized }
    }

    func handleDragChange(value: DragGesture.Value) {
        guard shape == .maximized else { return }
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

    var topPadding: CGFloat { shape == .maximized ? UIScreen.main.bounds.width / 6 + 26 : 0 }

    var cornerRadius: CGFloat { shape == .maximized ? 40 : 0 }

    var coverArtSize: CGFloat { shape == .maximized ? UIScreen.main.bounds.width / 1.5 : 48 }

    var coverArtCornerRadius: CGFloat { shape == .maximized ? 9 : 3 }

    var gripHeight: CGFloat { shape == .maximized ? 5 : 0 }

    var bottomInset: CGFloat { shape == .maximized ? 0 : Constants.minimizedBottomInset }

    func togglePlay() {
        withAnimation {
            viewModel.togglePlay()
        }
    }

    func backward() {
        withAnimation {
            viewModel.backward()
        }
    }

    func forward() {
        withAnimation {
            viewModel.forward()
        }
    }

    func airplay() {
        print("airplay pressed")
    }

    // swiftlint:disable nesting
    enum Constants {
        enum Minimized {
            enum Buttons {
                static let spacing: CGFloat = 4
                static let buttonSize: CGFloat = 40
                static let playImageOffset: CGFloat = -2
            }
        }
        
        enum Maximized {
            enum Buttons {
                static let spacing: CGFloat = 28
                static let playImageOffset: CGFloat = -4
                static let playButtonSize: CGFloat = 80
                static let playImageScale: CGFloat = 0.6
                static let switchButtonSize: CGFloat = 70
            }
        }
        
        static let backwardButtonImage = "backward.fill"
        static let forwardButtonImage = "forward.fill"
        static let playButtonImage = "play.fill"
        static let stopButtonImage = "stop.fill"
        static let pauseButtonImage = "pause.fill"
        
        static let minimizedHeight: CGFloat = 80
        static let minimizedBottomInset: CGFloat = 0
        static let minimizedHorizontalPadding: CGFloat = 20
        static let maximizedHorizontalPadding: CGFloat = 32
        static let maximizedTitlePadding: CGFloat = 64
        static let horizontalPadding: CGFloat = 20
        static let gripWidth: CGFloat = 36
    }

    var grip1: some View {
        Capsule()
            .fill(Color.gray)
            .frame(width: shape == .maximized ? 60 : 0, height: shape == .maximized ? 4 : 0)
            .opacity(shape == .maximized ? 1 : 0)
            .padding(.top, shape == .maximized ? safeArea?.top : 0)
            .padding(.vertical, shape == .maximized ? 30 : 0)
    }

    var grip: some View {
        Capsule()
            .fill(Color.gray)
            .frame(width: Constants.gripWidth, height: gripHeight)
            .padding(.top, shape == .maximized ? safeArea?.top : 0)
    }
}

struct PlayerView_Previews: PreviewProvider {
    @State static var playerShape = PlayerView.Shape.maximized
    static var previews: some View {
        PlayerView(shape: $playerShape)
    }
}
