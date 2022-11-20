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
    //static关键字让它们变成全局变量EmojiMemoryGame.xxx,表示不是实例而是类型本身具有的变量或函数
    static let car = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚛", "🛺", ]
    static let food = ["🍎", "🍆", "🥕", "🫑", "🧅", "🍅", "🍈", "🍇", "🍍", "🌯", "🍝", ]
    static let play = ["⚽️", "🪀",  "🎾", "🏋🏻", "🥌", "⛸️",  "🎸","🚣‍♀️" ]
    static let emojis = ["🍙", "🍰", "🧁", "🍭", "🍝", "🍲", "🥫", "🌮", "🥪", "🧇", "🍈", "🥥", "🍓", "🍋"]
    
    //独立出来,让代码更加简洁
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4){ pairIndex in
            //使用了全名
            EmojiMemoryGame.emojis[pairIndex]
        }
    }
    
    //创建一个model,并通过“private”保护它不被view直接修改,(set)表示UI可以看不能改(也可以另外搞个变量来返回model.cards),@Published表示只要model改变就广播
    @Published private(set) var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    func choose (_ card: MemoryGame<String>.Card ){
        model.choose(card)
        //发送改变了的广播 objectWillChange.send()
        
    }
}
