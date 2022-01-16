//
//  EmojiMemoryGameView.swift
//  Concentration
//
//  Created by Rhea Malik on 6/18/21.
//  Copyright © 2021 Rhea Malik. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    // so that whenever the viewmodel publishes a change, the view will refresh
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("\(game.theme.name)")
                    .font(.largeTitle)
                Spacer()
                Text("Score: \(game.getScore())")
                    .font(.largeTitle)
                Spacer()
            }
            
            gameBody
            Spacer()
            
            HStack {
                Spacer()
                shuffle
                Spacer()
                Button("New Game") {
                    game.refresh()
                    resetDealt()
                }
                Spacer()
            }
            
        }
        .padding(.horizontal)
    }
    
    @State private var dealt = Set<Int>() // set of identifiers for dealt cards
    
    private func resetDealt() {
        dealt = Set<Int>()
    }
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id) // don't need return statement bc one line
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            CardView(card: card, color: game.theme.color)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                .padding(4)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        game.choose(card)
                    }
                }
        })
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter {isUndealt($0)}) { card in
                CardView(card: card, color: game.theme.color)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }
        .frame(width: 60, height: 90)
        .foregroundColor(game.theme.color)
        .onTapGesture {
            // deal cards
            withAnimation(.easeInOut(duration: 2)) {
                for card in game.cards {
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    
    //    var travel: some View {
    //        Button {
    //            theme = 1
    //        } label : {
    //            VStack {
    //                Image(systemName: "car")
    //                    .font(.largeTitle)
    //                Text("Travel")
    //            }
    //        }
    //    }
    //
    //    var games: some View {
    //        Button {
    //            theme = 2
    //        } label : {
    //            VStack {
    //                Image(systemName: "gamecontroller")
    //                    .font(.largeTitle)
    //                Text("Games")
    //            }
    //        }
    //    }
    //
    //    var animal: some View {
    //        Button {
    //            theme = 3
    //        } label : {
    //            VStack {
    //                Image(systemName: "tortoise")
    //                    .font(.largeTitle)
    //                Text("Animals")
    //            }
    //        }
    //    }
    
    //    var remove: some View {
    //        Button {
    //            if emojiCount > 1 {
    //                emojiCount -= 1
    //            }
    //        } label: {
    //            Image(systemName: "minus.circle")
    //        }
    //    }
    //
    //    var add: some View {
    //        Button(action: {
    //            if emojiCount < emojis.count {
    //                emojiCount += 1
    //            }
    //        }, label: {
    //            Image(systemName: "plus.circle")
    //        })
    //    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    let color: Color
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360 - 90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360 - 90))
                    }
                }
                .foregroundColor(color)
                .padding(5)
                .opacity(0.5)
                Text(card.content)
                    .rotationEffect(card.isMatched ? Angle.degrees(360) : Angle.degrees(0))
                    .animation(.easeInOut(duration: 1.5))
                    .font(Font.system(size: K.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp, color: color, isShown: !card.isMatched)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        return min(size.width, size.height) / (K.fontSize/K.fontScale)
    }
    
    private struct K { // struct for constants
        static let fontSize: CGFloat = 32
        static let fontScale: CGFloat = 0.7
        static let timerOpacity: Double = 0.5
        static let timerPadding: CGFloat = 5
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game).preferredColorScheme(.light)
        EmojiMemoryGameView(game: game).preferredColorScheme(.dark)
    }
}
