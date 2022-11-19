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
    var emojis = ["🍙", "🍰", "🧁", "🍭", "🍝", "🍲", "🥫", "🌮", "🥪", "🧇", "🍈", "🥥", "🍓", "🍋"]
    var emojiCount = 6
    
    var body: some View {
        HStack{
            /*
             content由于是最后一个参数被省略了
            ForEach(emojis,id: \.self, content: { emoji in
                CardView(content: emoji)
            })
             */
            ForEach(emojis[0..<emojiCount],id: \.self) { emoji in
                CardView(content: emoji)
            }
        }
        .padding(.vertical)
        .foregroundColor(Color.red)
    }
}

struct CardView : View{
    var content:String
    @State var isFaceUp : Bool = true
    
    var body: some View{
        ZStack{
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp{
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: 3)
                Text(content).font(.largeTitle)
            }else{
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}
   












//preview需要的,不需要看它
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //可以通过设置多个ContentView()来看不同的模拟效果
        ContentView()
    }
}
