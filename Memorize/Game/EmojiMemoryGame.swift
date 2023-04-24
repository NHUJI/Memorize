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

    static var oneInit = false // 保证一次点击只有一次init

    let userDefaultsManager = UserDefaultsManager()
    @Published var isResumingGame: Bool = false // 是否恢复游戏(用于提示框),不能在VM使用"@State"

    init(chosenTheme: Theme) {
        self.chosenTheme = chosenTheme
        self.model = MemoryGame<String>(theme: chosenTheme) { pairIndex in
            chosenTheme.cardsSet[pairIndex]
        }
        if EmojiMemoryGame.oneInit {
            let theme = userDefaultsManager.readThemeFromUserDefaults()
            if theme == chosenTheme {
                self.model = userDefaultsManager.readModelFromUserDefaults() ?? MemoryGame<String>(theme: chosenTheme) { pairIndex in
                    chosenTheme.cardsSet[pairIndex]
                }
                self.isResumingGame = true
                print("恢复游戏: \(model.theme.name)")
            } else {
                UserDefaultsManager().storeModelInUserDefaults(model: model) // 存储新游戏的模型
            }
            userDefaultsManager.storeThemeInUserDefaults(theme: chosenTheme)
        }
        print("\(isResumingGame.description)")
        EmojiMemoryGame.oneInit.toggle() // toggle保证两次初始化里只有一次可以存储主题
    }

    // 生成内容的函数 独立出来,让代码更加简洁
    func createMemoryGame(chosenTheme: Theme) -> MemoryGame<String> {
        MemoryGame<String>(theme: chosenTheme) { pairIndex in
            // 使用了全名
            chosenTheme.cardsSet[pairIndex]
        }
    }

    // 创建一个model,并通过“private”保护它不被view直接修改,(set)表示UI可以看不能改(也可以另外搞个变量来返回model.cards),@Published表示只要model改变就广播
    @Published private(set) var model: MemoryGame<String> {
        didSet {
            UserDefaultsManager().storeModelInUserDefaults(model: model)
            print("存储模型: \(model)")
        }
    }

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

struct UserDefaultsManager {
    // 传入的主题和模型的key
    private var userThemeKey: String { "UserTheme" }
    private var userModelKey: String { "UserModel" }

    // 存储主题和模型
    func storeModelInUserDefaults(model: MemoryGame<String>) {
        UserDefaults.standard.set(try? JSONEncoder().encode(model), forKey: userModelKey)
    }

    func storeThemeInUserDefaults(theme: ThemeChooser.Theme) {
        UserDefaults.standard.set(try? JSONEncoder().encode(theme), forKey: userThemeKey)
    }

    // 读取主题和模型并返回
    func readThemeFromUserDefaults() -> ThemeChooser.Theme? {
        if let data = UserDefaults.standard.data(forKey: userThemeKey),
           let theme = try? JSONDecoder().decode(ThemeChooser.Theme.self, from: data)
        {
            return theme
        }
        return nil
    }

    func readModelFromUserDefaults() -> MemoryGame<String>? {
        if let data = UserDefaults.standard.data(forKey: userModelKey),
           let model = try? JSONDecoder().decode(MemoryGame<String>.self, from: data)
        {
            return model
        }
        return nil
    }
}
