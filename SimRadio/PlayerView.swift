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

    @State var volume: CGFloat = 0
    @State var offset: CGFloat = 0
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    @StateObject var viewModel: ViewModel
    @Binding var shape: Shape
    
    var body: some View {
        ZStack(alignment: .top) {
            BlurView().onTapGesture { maximize() }
                .cornerRadius(Constants.cornerRadius(for: shape))
                .frame(maxHeight: shape == .maximized ? .infinity : Constants.minimizedHeight)

            miniPlayer
            
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

    var playerControls: some View {
        HStack(spacing: 64) {
            Button(action: backward) { Image(systemName: "backward.fill") }
            Button(action: play) { Image(systemName: "play.fill").font(.system(size: 50)) }
            Button(action: forward) { Image(systemName: "forward.fill") }
        }
        .font(.largeTitle)
        .foregroundColor(.primary)
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
                HStack(spacing: 20) {
                    Button(action: play) { Image(systemName: "play.fill") }
                    Button(action: forward) { Image(systemName: "forward.fill") }
                }
                .font(.title2)
                .foregroundColor(.primary)
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

    var topPadding: CGFloat {
        shape == .maximized ? UIScreen.main.bounds.width / 6 + 26 : 0
    }

    var coverArtSize: CGFloat {
        shape == .maximized ? UIScreen.main.bounds.width / 1.5 : 48
    }

    var coverArtCornerRadius: CGFloat { shape == .maximized ? 9 : 3 }
    
    var gripHeight: CGFloat { shape == .maximized ? 5 : 0 }

    func play() {
        viewModel.togglePlayStop()
    }

    func backward() {
        viewModel.backward()
    }

    func forward() {
        viewModel.forward()
    }

    func airplay() {
        print("airplay pressed")
    }

    enum Constants {
        static func cornerRadius(for shape: Shape) -> CGFloat { shape == .maximized ? 40 : 0 }
        static func bottomInset(for shape: Shape) -> CGFloat { shape == .maximized ? 0 : minimizedBottomInset }

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
