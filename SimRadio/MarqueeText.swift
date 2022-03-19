//
//  MarqueeText.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 18.03.2022.
//

import SwiftUI

struct MarqueeText: View {
    let text: String
    let font: UIFont
    let leftFade: CGFloat
    let rightFade: CGFloat
    let startDelay: Double
    var alignment = Alignment.topLeading

    @State private var animate = false

    var body: some View {
        let textSize = textSize

        let animation = Animation
            .linear(duration: Double(textSize.width) / 30)
            .delay(startDelay)
            .repeatForever(autoreverses: false)

        return ZStack {
            GeometryReader { geo in
                if textSize.width > geo.size.width { // don't use self.animate as conditional here
                    Group {
                        Text(text)
                            .offset(x: animate ? -textSize.width - textSize.height * 2 : 0)
                            .animation(animate ? animation : nil, value: animate)
                            .onAppear {
                                Task.init {
                                    try await Task.sleep(nanoseconds: 500_000_000)
                                    animate = geo.size.width < textSize.width
                                }
                            }
                        Text(text)
                            .offset(x: animate ? 0 : textSize.width + textSize.height * 2)
                            .animation(animate ? animation : nil, value: animate)
                    }
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(
                        minWidth: 0, maxWidth: .infinity,
                        minHeight: 0, maxHeight: .infinity,
                        alignment: alignment
                    )
                    .offset(x: leftFade)
                    .mask(fadeMask)
                    .frame(width: geo.size.width + leftFade)
                    .offset(x: -leftFade)
                } else {
                    Text(text)
                        .frame(
                            minWidth: 0, maxWidth: .infinity,
                            minHeight: 0, maxHeight: .infinity,
                            alignment: alignment
                        )
                }
            }
        }
        .font(.init(font))
        .frame(height: textSize.height)
    }
    
    private var fadeMask: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 2)
                .opacity(0)
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                startPoint: .leading, endPoint: .trailing
            )
            .frame(width: leftFade)
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.black]),
                startPoint: .leading, endPoint: .trailing
            )
            
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]),
                startPoint: .leading, endPoint: .trailing
            )
            .frame(width: rightFade)
            
            Rectangle()
                .frame(width: 2)
                .opacity(0)
        }
    }
    
    private var textSize: CGSize {
        text.size(withAttributes: [NSAttributedString.Key.font: font])
    }
}

struct MarqueeText_Previews: PreviewProvider {
    static var previews: some View {
        MarqueeText(
            text: "A subtitle that is way too long, but it scrolls homie",
            font: UIFont.systemFont(ofSize: 30),
            leftFade: 32,
            rightFade: 32,
            startDelay: 3
        )
        .frame(width: 300)
        .background(Color.green.opacity(0.5))
    }
}
