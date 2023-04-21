//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by huhu on 2022/11/20.
//
//  MVVM的ViewModel 并且是emoji的 并且VM主要使用Class

import SwiftUI

// ObservableObject表示可以广播改变
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    typealias Theme = ThemeChooser.Theme
    
    var chosenTheme: Theme // 选择的主题(参数)
    init(chosenTheme: Theme) {
        self.chosenTheme = chosenTheme
        self.model = MemoryGame<String>(theme: chosenTheme) { pairIndex in
            // 使用了全名
            chosenTheme.cardsSet[pairIndex]
        }
    }
    
    // 生成内容的函数 独立出来,让代码更加简洁
    func createMemoryGame(chosenTheme: Theme) -> MemoryGame<String> {
        MemoryGame<String>(theme: chosenTheme) { pairIndex in
            // 使用了全名
            chosenTheme.cardsSet[pairIndex]
        }
    }
   
    // 创建一个model,并通过“private”保护它不被view直接修改,(set)表示UI可以看不能改(也可以另外搞个变量来返回model.cards),@Published表示只要model改变就广播
    @Published private(set) var model: MemoryGame<String>
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    var currentTheme: MemoryGame<String>.Theme {
        model.theme
    }
    
    // MARK: - Intent(s)

    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
        // 发送改变了的广播 objectWillChange.send()
    }
    
    func newGame() {
        model = createMemoryGame(chosenTheme: chosenTheme)
    }
   
    func shuffle() {
        model.shuffle()
    }
}
