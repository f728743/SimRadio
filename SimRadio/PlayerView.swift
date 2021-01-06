//
//  PlayerView.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 05.01.2021.
//

import SwiftUI

enum PlayerShape {
    case expanded
    case collapsed
}

struct PlayerView: View {
    
    var animation: Namespace.ID
    @Binding var shape: PlayerShape
    
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var volume: CGFloat = 0
    
    @State var offset: CGFloat = 0
    
    let title = "Los Santos Rock Radio"
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.gray)
                .frame(width: shape == .expanded ? 60 : 0, height: shape == .expanded ? 4 : 0)
                .opacity(shape == .expanded ? 1 : 0)
                .padding(.top, shape == .expanded ? safeArea?.top : 0)
                .padding(.vertical, shape == .expanded ? 30 : 0)
            
            HStack(spacing: 15) {
                
                if shape == .expanded { Spacer(minLength: 0) }
                
                Image("radio_01_class_rock")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Settings.coverArtSize(for: shape),
                           height: Settings.coverArtSize(for: shape))
                    .cornerRadius(15)
                
                if shape == .collapsed {
                    Text(title).opacity(shape == .collapsed ? 1 : 0)
                }
                
                Spacer(minLength: 0)
                
                if shape == .collapsed {
                    Button(action: {}, label: {
                        Image(systemName: "play.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                    
                    Button(action: {}, label: {
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    })
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 15) {
                Spacer(minLength: 0)
                
                HStack {
                    if shape == .expanded {
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
                
                LiveIndicatorView().padding()
                
                Button(action: stop) {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                }
                .padding()
                
                Spacer(minLength: 0)
                
                HStack(spacing: 15) {
                    Image(systemName: "speaker.fill")
                    
                    Slider(value: $volume)
                    
                    Image(systemName: "speaker.wave.2.fill")
                }
                .padding()
                
                Button(action: airplay) {
                    Image(systemName: "airplayaudio")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                .padding(.bottom, safeArea?.bottom == 0 ? 15 : safeArea?.bottom)
            }
            // strech effect
            .frame(height: shape == .expanded ? nil : 0)
            .opacity(shape == .expanded ? 1 : 0)
        }
        // expanding to full screen when clicked
        .frame(maxHeight: shape == .expanded ? .infinity : Settings.collapsedHeight)
        
        // Divider Line For Separting Miniplayer And Tab Bar
        .background(
            VStack(spacing: 0) {
                BlurView()
                Divider()
            }
            .onTapGesture {
                withAnimation(.spring()) { shape = .expanded }
            }
        )
        .cornerRadius(shape == .expanded ? Settings.expandCornerRadius : 0)
        .offset(y: shape == .expanded ? 0 : -Settings.collapsedBottomOffset)
        .offset(y: offset)
        .gesture(DragGesture().onEnded(onended(value:)).onChanged(onchanged(value:)))
        .ignoresSafeArea()
    }
    
    func onchanged(value: DragGesture.Value) {
        guard shape == .expanded else { return }
        
        if value.translation.height > 0 {
            offset = value.translation.height
        }
    }
    
    func onended(value: DragGesture.Value) {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)) {
            if value.translation.height > 80 {
                shape = .collapsed
            }
            offset = 0
        }
    }
    
    func stop() {
        print("stop pressed")
    }
    
    func airplay() {
        print("airplay pressed")
    }
    
    enum Settings {
        static func coverArtSize(for shape: PlayerShape) -> CGFloat {
            shape == .expanded ? UIScreen.main.bounds.height / 3 : 55
        }
        
        static let expandedCoverArtSize: CGFloat = UIScreen.main.bounds.height / 3
        static let expandCornerRadius: CGFloat = 40
        static let collapsedHeight: CGFloat = 80
        static let collapsedBottomOffset: CGFloat = 0
    }
}

struct LiveIndicatorView: View {
    var body: some View {
        HStack {
            Capsule()
                .fill(LinearGradient(
                        gradient: Gradient(colors: [Settings.opaque, Settings.transparent]),
                        startPoint: .leading,
                        endPoint: .trailing))
                .frame(height: Settings.barWidth)
            
            Text("LIVE")
                .font(.title3)
                .foregroundColor(.primary)
            
            Capsule()
                .fill(LinearGradient(
                        gradient: Gradient(colors: [Settings.transparent, Settings.opaque]),
                        startPoint: .leading,
                        endPoint: .trailing))
                .frame(height: Settings.barWidth)
        }
    }
    
    enum Settings {
        static let opaque: Color = Color.primary.opacity(0.7)
        static let transparent: Color = Color.primary.opacity(0.1)
        static let barWidth: CGFloat = 4
        static let separatorInset: CGFloat = 20
    }
}
