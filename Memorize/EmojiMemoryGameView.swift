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
            gameBody.padding(.horizontal)
            HStack{
                shuffle
                Spacer()
                newGame
            }
            .padding()
        }
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card)
                    .padding(DrawingConstants.padding)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .slide))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .onAppear {
            withAnimation {
                //为了卡片出现的效果,当AspectVGrid出现后才显示卡片
                for card in game.cards {
                    deal(card)
                }
            }
        }
        .foregroundColor(game.currentTheme.cardColor)
    }
    
    var shuffle: some View {
        Button("Shuffle"){
            withAnimation {
                game.shuffle()
            }
            
        }
    }
    
    var newGame: some View {
        //TODO: 修复新游戏后卡片动画没有重置的问题
        Button(action: {
            withAnimation() {
                game.newGame()
            }
        }, label:{
            Text("New Game")
        })
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
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false),value: card.isMatched) //iOS15开始要求加入触发动画的改变值
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size ))
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
