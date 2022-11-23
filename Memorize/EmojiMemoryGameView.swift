//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by huhu on 2022/11/15.
//

//使用SwiftUI,逻辑文件就不需要UI
import SwiftUI

//结构:变量的集合 不仅有变量也可以有函数
struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    var body: some View {
        VStack {
            Text(game.currentTheme.name).font(.largeTitle).foregroundColor(game.currentTheme.cardColor)
            Text("score: \(game.model.score)").foregroundColor(game.currentTheme.cardColor)
            ScrollView {
                CardsView
            }
            .foregroundColor(game.currentTheme.cardColor)
            .padding(.horizontal)
            Button(action: {
                game.newGame()
            }, label:{
                Text("New Game").font(.largeTitle)
            })
        }
    }
    
    var CardsView: some View{
        //TODO: 根据卡片数量决定一行显示多少
        LazyVGrid(columns: [GridItem(.adaptive(minimum: cardsWidth(cardsNumber: game.cards.count) ))]){
            ForEach(game.cards) { card in
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            game.choose(card)
                            //print(game.cards)
                        }
            }
        }
    }
    private func cardsWidth(cardsNumber: Int) -> CGFloat {
        if cardsNumber <= 4 {
            return 120
        } else if cardsNumber <= 10{
            return 80
        } else if cardsNumber <= 20{
            return 70
        } else {
            return 50
        }
    }
    

    
}


struct CardView: View{
    private let card: EmojiMemoryGame.Card
    
    //这样就不需要输入CardView(card: card),不过这样有点多余
    init(_ card: EmojiMemoryGame.Card){
        self.card = card
    }
    
    var body: some View{
        GeometryReader { geometry in
            ZStack{
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp{
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Text(card.content).font(font(in: geometry.size))
                }else if card.isMatched{
                    Text(" ").font(font(in: geometry.size))
                    shape.opacity(DrawingConstants.cardOpacity)
                }else{
                    shape.fill()
                    //全名Font.largeTitle,是static变量
                    Text(" ").font(font(in: geometry.size))
                }
            }
        }
    }
    
    //单独函数让view结构保持简洁
    private func font(in size: CGSize ) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    //去掉代码中的魔法数字
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        static let cardOpacity: CGFloat = 0.3
    }
    
    
    
    
}













//preview需要的,不需要看它
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        //可以通过设置多个EmojiMemoryGameView()来看不同的模拟效果
        EmojiMemoryGameView(game: game)
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
    }
}
