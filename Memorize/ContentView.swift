//
//  ContentView.swift
//  Memorize
//
//  Created by huhu on 2022/11/15.
//

//使用SwiftUI,逻辑文件就不需要UI
import SwiftUI

//结构:变量的集合 不仅有变量也可以有函数
struct ContentView: View {
    @ObservedObject var viewMoedl: EmojiMemoryGame
    //不明白这里为什么不能放vm而是放的emg
    @State var fgColor = EmojiMemoryGame.chosenTheme.cardColor
    var body: some View {
        VStack{
            Text(viewMoedl.currentTheme.name).font(.largeTitle).foregroundColor(viewMoedl.currentTheme.cardColor)
            ScrollView {
                CardsView
            }
            .foregroundColor(fgColor)
            .padding(.horizontal)
            Button(action: {
                viewMoedl.newGame()
                fgColor = viewMoedl.currentTheme.cardColor
            }, label:{
                Text("New Game").font(.largeTitle)
            }
            )
        }
    }
    
    var CardsView: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]){
            ForEach(viewMoedl.cards) { card in
                    CardView(card: card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture {
                            viewMoedl.choose(card)
                        }
            }
        }
    }
    

    
}


struct CardView: View{
    let card: MemoryGame<String>.Card
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
        //可以通过设置多个ContentView()来看不同的模拟效果
        ContentView(viewMoedl: game)
        ContentView(viewMoedl: game)
            .preferredColorScheme(.dark)
    }
}
