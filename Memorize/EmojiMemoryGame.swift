//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by huhu on 2022/11/20.
//
//MVVM的ViewModel 并且是emoji的 并且VM主要使用Class

import SwiftUI

//ObservableObject表示可以广播改变
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    typealias Theme = MemoryGame<String>.Theme
    
    private static var car = Theme(name: "car", cardsSet: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚛", "🛺", ], pairsOfCards: 11, cardColor: .red)
    private static var food = Theme(name: "food", cardsSet: ["🍎", "🍆", "🥕", "🫑", "🧅", "🍅", "🍈", "🍇", "🍍", "🌯", "🍝", ], pairsOfCards: 11, cardColor: .blue)
    private static var play = Theme(name: "play", cardsSet: ["⚽️", "🪀",  "🎾", "🏋🏻", "🥌", "⛸️",  "🎸","🚣‍♀️" ], pairsOfCards: 8, cardColor: .mint)
    private static var mess = Theme(name: "mess", cardsSet:["🍙", "🍰", "🧁", "🍭", "🍝", "🍲", "🥫", "🌮", "🥪", "🧇", "🍈", "🥥", "🍓", "🍋"], pairsOfCards:14 , cardColor: .orange)
    private static var themes: Array<Theme> = [car, food, play, mess]
    private static var chosenTheme = themes.randomElement()!
    
    //生成内容的函数 独立出来,让代码更加简洁
    static func createMemoryGame(randomTheme: EmojiMemoryGame.Theme) -> MemoryGame<String> {
        //生成model需要卡片对的数量和生成卡片内容的函数
        MemoryGame<String>(theme: chosenTheme){ pairIndex in
            //使用了全名
            randomTheme.cardsSet[pairIndex]
        }
    }
   
 
    //创建一个model,并通过“private”保护它不被view直接修改,(set)表示UI可以看不能改(也可以另外搞个变量来返回model.cards),@Published表示只要model改变就广播
    @Published private(set) var model = createMemoryGame(randomTheme: chosenTheme )
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var currentTheme: MemoryGame<String>.Theme {
        model.theme
    }
    
    
    // MARK: - Intent(s)
    func choose (_ card: MemoryGame<String>.Card ){
        model.choose(card)
        //发送改变了的广播 objectWillChange.send()
        
    }
    
    func newGame() {
        EmojiMemoryGame.chosenTheme = EmojiMemoryGame.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(randomTheme: EmojiMemoryGame.chosenTheme )
    }
   
}
