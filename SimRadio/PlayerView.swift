//
//  PlayerView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 05.01.2021.
//

import SwiftUI

struct PlayerView: View {
    enum Shape {
        case maximized
        case minimized
    }

    @Binding var shape: Shape
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    @State var volume: CGFloat = 0
    @State var offset: CGFloat = 0
    let title = "Los Santos Rock Radio"

    @ObservedObject var viewModel: PlayerViewModel

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                grip
                coverArt
                VStack(spacing: 15) {
                    Spacer(minLength: 0)
                    trackInfo
                    liveIndicator
                    playerControls
                    Spacer(minLength: 0)
                    volumeControl
                    airplayButton
                }
                // strech effect
                .frame(height: shape == .maximized ? nil : 0)
                .opacity(shape == .maximized ? 1 : 0)
            }
            // expanding to full screen when clicked
            .frame(maxHeight: shape == .maximized ? .infinity : Constants.collapsedHeight)

            // Divider Line For Separting Miniplayer And Tab Bar
            .background(
                VStack(spacing: 0) {
                    BlurView()
                    Divider()
                }
                .onTapGesture {
                    withAnimation(.spring()) { shape = .maximized }
                }
            )
            .cornerRadius(shape == .maximized ? Constants.expandCornerRadius : 0)
            .offset(y: shape == .maximized ? 0 : -Constants.collapsedBottomOffset)

            miniPlayer
        }
        .offset(y: offset)
        .gesture(DragGesture().onEnded(handleDragEnd(value:)).onChanged(handleDragChange(value:)))
        .ignoresSafeArea()
    }

    var grip: some View {
        Capsule()
            .fill(Color.gray)
            .frame(width: shape == .maximized ? 60 : 0, height: shape == .maximized ? 4 : 0)
            .opacity(shape == .maximized ? 1 : 0)
            .padding(.top, shape == .maximized ? safeArea?.top : 0)
            .padding(.vertical, shape == .maximized ? 30 : 0)
    }

    var coverArt: some View {
        HStack(spacing: 15) {
            if shape == .maximized { Spacer(minLength: 0) }

            Image("radio_01_class_rock")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: Constants.coverArtSize(for: shape),
                       height: Constants.coverArtSize(for: shape))
                .cornerRadius(15)

            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }

    var trackInfo: some View {
        HStack {
            if shape == .maximized {
                Text(title).font(.title3)
            }

            Spacer(minLength: 0)

            Button(action: {}, label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title2)
                    .foregroundColor(.primary)
            })
        }
        .padding()
        .padding(.top, 20)
    }

    var liveIndicator: some View {
        LiveIndicatorView().padding()
    }

    var playerControls: some View {
        HStack(spacing: 64) {
            Button(action: backward) {
                Image(systemName: "backward.fill")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }

            Button(action: play) {
                Image(systemName: "play.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.primary)
            }

            //            Button(action: stop) {
            //                Image(systemName: "stop.fill")
            //                    .font(.largeTitle)
            //                    .foregroundColor(.primary)
            //            }

            Button(action: forward) {
                Image(systemName: "forward.fill")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }
        }
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
        .padding(.bottom, safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
    }

    var miniPlayer: some View {
        ZStack {
            //                Color(.yellow).opacity(0.3).onTapGesture {
            //                    withAnimation(.spring()) { shape = .expanded }
            //                }
            HStack {
                Text(title).padding(.leading, Constants.collapsedTitlePadding)
                Spacer(minLength: 0)
                HStack(spacing: 20) {
                    Button(action: play) { Image(systemName: "play.fill") }
                    Button(action: forward) { Image(systemName: "forward.fill") }
                }
                .font(.title2)
                .foregroundColor(.primary)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .opacity(shape == .minimized ? 1 : 0)
        }.frame(height: Constants.collapsedHeight)
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

    func stop() {
        print("stop pressed")
    }

    func play() {
        print("play pressed")
    }

    func backward() {
        print("backward pressed")
    }

    func forward() {
        print("forward pressed")
    }

    func airplay() {
        print("airplay pressed")
    }

    enum Constants {
        static func coverArtSize(for shape: Shape) -> CGFloat {
            shape == .maximized ? UIScreen.main.bounds.height / 3 : 48
        }

        static let expandedCoverArtSize: CGFloat = UIScreen.main.bounds.height / 3
        static let expandCornerRadius: CGFloat = 40

        static let collapsedTitlePadding: CGFloat = 64
        static let collapsedHeight: CGFloat = 80
        static let collapsedBottomOffset: CGFloat = 0
        static let horizontalPadding: CGFloat = 20
    }
}
