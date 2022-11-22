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
        VStack{
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]){
            ForEach(game.cards) { card in
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            game.choose(card)
                            print(game.cards)
                        }
            }
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
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp{
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            }else if card.isMatched{
                Text(" ").font(.largeTitle)
                shape.opacity(0.3)
            }else{
                shape.fill()
                //全名Font.largeTitle,是static变量
                Text(" ").font(.largeTitle)
            }
        }
        
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
