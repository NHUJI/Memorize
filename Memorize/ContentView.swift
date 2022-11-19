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
    var car = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚛", "🛺", ]
    var food = ["🍎", "🍆", "🥕", "🫑", "🧅", "🍅", "🍈", "🍇", "🍍", "🌯", "🍝", ]
    var play = ["⚽️", "🪀",  "🎾", "🏋🏻", "🥌", "⛸️",  "🎸","🚣‍♀️" ]
    @State public var emojis = ["🍙", "🍰", "🧁", "🍭", "🍝", "🍲", "🥫", "🌮", "🥪", "🧇", "🍈", "🥥", "🍓", "🍋"]
    @State var emojiCount = 8
    var minNumberOfCards = 3
    
    var body: some View {
        
        VStack{
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                CardsView
            }
            .foregroundColor(Color.red)
            Spacer()
            themeButton
        }
        .padding(.horizontal)
        
    }

//    var remove: some View{
//        //简洁写法
//        Button {
//            if emojiCount > 1 {
//                emojiCount -= 1
//            }
//        }label: {
//            Image(systemName: "minus.circle")
//        }
//    }
//
//    var add: some View{
//        //完全的写法
//        Button(action: {
//            if emojiCount < emojis.count{
//                emojiCount += 1
//            }
//        },label: {
//           Image(systemName: "plus.circle")
//        })
//    }
    var CardsView: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]){
            ForEach(emojis[0..<Int.random(in: minNumberOfCards...emojiCount)],id: \.self) { emoji in
                    CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
            }
        }
    }
    
    var themeButton: some View{
        HStack{
            Theme(theme: "car", image: "car")
                .padding(.horizontal)
                .onTapGesture {emojis = play.shuffled()}
            Theme(theme: "food", image: "takeoutbag.and.cup.and.straw")
                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                .onTapGesture {emojis = play.shuffled()}
            Theme(theme: "play", image: "gamecontroller")
                .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                .onTapGesture {emojis = play.shuffled()}
        }
    }
    
}


struct CardView: View{
    var content:String
    @State var isFaceUp : Bool = true
    var body: some View{
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp{
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            }else{
                shape.fill()
                //避免反转后卡片大小不一致的问题
                Text(" ").font(.largeTitle)
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct Theme: View{
    @State  var fgColor: Color = .blue
    
    var theme:String
    var image:String
    var body: some View{
        VStack{
            Image(systemName: image).font(.largeTitle)
            Text(theme)
        }
        .foregroundColor(fgColor)
    }
}












//preview需要的,不需要看它
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //可以通过设置多个ContentView()来看不同的模拟效果
        ContentView()
        ContentView()
            .preferredColorScheme(.dark)
    }
}
