//
//  SidePadding.swift
//  SimRadio
//
//  Created by Alexey Vorobyov on 17.03.2022.
//

import SwiftUI

struct SidePadding: ViewModifier {
    enum Side {
        case left, right
    }

    let edge: Side
    let length: CGFloat?
    @Environment(\.layoutDirection) var layoutDirection

    private var computedEdge: Edge.Set {
        if layoutDirection == .rightToLeft {
            return edge == .left ? .trailing : .leading
        } else {
            return edge == .left ? .leading : .trailing
        }
    }

    func body(content: Content) -> some View {
        content
            .padding(computedEdge, length)
    }
}

extension View {
    func padding(_ edge: SidePadding.Side, _ length: CGFloat? = nil) -> some View {
        modifier(SidePadding(edge: edge, length: length))
    }
}
