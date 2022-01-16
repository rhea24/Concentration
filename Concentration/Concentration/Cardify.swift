//
//  Cardify.swift
//  Concentration
//
//  Created by Rhea Malik on 7/22/21.
//  Copyright © 2021 Rhea Malik. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var color: Color
    var isShown: Bool
    
    var rotation: Double //  in degrees
    
    init(isFaceUp: Bool, color: Color, isShown: Bool) {
        rotation = isFaceUp ? 0 : 180
        self.color = color
        self.isShown = isShown
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: K.cornerRadius)
                if !isShown { // if card is matched, so card should not be shown
                    shape.opacity(0) // blank card
                    content
                        .opacity(rotation < 90 ? 1 : 0) // shows content regardless - if card is face up - (till next one pressed)
                }
                else if rotation < 90 { // if the card isn't matched and is face up
                    shape
                        .fill()
                        .foregroundColor(.white) // make a white card background
                    shape
                        .strokeBorder(lineWidth: K.lineWidth)
                        .foregroundColor(color) // make a card border of the theme color
                    content
                        .opacity(rotation < 90 ? 1 : 0) // show content if face up, not if face down (should always be face up but fine to confirm with ternary)
                }
                else { // if card is face down
                    shape
                        .fill(color) // back of card is theme color
                    content
                        .opacity(rotation < 90 ? 1 : 0) // show content if face up, not if face down (should always be face down but fine to confirm with ternary)
                }
            }
            .rotation3DEffect(
                Angle.degrees(rotation),
                axis: (x: 0.0, y: 1.0, z: 0.0) // flipping card over effect
            )
        })
    }
    private struct K { // struct for constants
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool, color: Color, isShown: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp, color: color, isShown: isShown))
    }
}
