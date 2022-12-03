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
            AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                cardView(for:  card)
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
    
    @ViewBuilder private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if card.isMatched && !card.isFaceUp{
            Color.clear
        } else {
            CardView(card)
                .padding(DrawingConstants.padding)
                .onTapGesture {
                    game.choose(card)
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
        GeometryReader { geometry in
            ZStack{
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                    .padding(5)
                    .opacity(0.5)
                Text(card.content)
                    //匹配成功后改变字符角度,360 : 0相当于转了一圈
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    //
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false),value: card.isMatched) //iOS15开始要求加入触发动画的改变值
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size )) //这两条是为了解决font不适用于动画的问题,现在已经不存在这个问题
            }.cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    // the "scale factor" to scale our Text up so that it fits the geometry.size offered to us
   private func scale(thatFits size: CGSize) -> CGFloat {
       min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
   }
    
  
   
    
    
    
    
}


//去掉代码中的魔法数字
private struct DrawingConstants {
    static let fontSize: CGFloat = 32
    static let fontScale: CGFloat = 0.6
    static let cardOpacity: CGFloat = 0.3
    static let padding: CGFloat = 4
}









//preview需要的,不需要看它
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        //可以通过设置多个EmojiMemoryGameView()来看不同的模拟效果
        return EmojiMemoryGameView(game: game)
        
    }
}
