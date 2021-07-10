//
//  Arrow.swift
//  Drawing
//
//  Created by Zaheer Moola on 2021/07/10.
//

import SwiftUI

struct Arrow: Shape {
    var lineWidth: CGFloat

    var animatableData: CGFloat {
        get { lineWidth }
        set { lineWidth = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let arrowSides = lineWidth * 6
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - arrowSides, y: rect.maxY - arrowSides))
        path.addLine(to: CGPoint(x: rect.midX - lineWidth, y: rect.maxY - arrowSides))
        path.addLine(to: CGPoint(x: rect.midX - lineWidth, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + lineWidth, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + lineWidth, y: rect.maxY - arrowSides))
        path.addLine(to: CGPoint(x: rect.midX + arrowSides, y: rect.maxY - arrowSides))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}
