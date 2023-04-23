//
//  ThemeChooser.swift
//  Memorize
//
//  Created by huhu on 2023/4/20.
//  ViewModel

import SwiftUI

// 主题选择器
class ThemeChooser: ObservableObject {
    let name: String // VM的名称

    // Model
    @Published var themes = [Theme]() {
        didSet {
            // TODO: 每次修改后自动保存数据
        }
    }

    // TODO: 存储,读取相关 包括key(userDefaultsKey)和存储函数(storeInUserDefaults, restoreFromUserDefaults)

    // 初始化
    init(name: String) {
        self.name = name
        // TODO: 读取数据
        if themes.isEmpty {
            print("使用内置主题 using built-in themes")
            insertTheme(name: "car", cardsSet: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚛", "🛺"], cardColor: .red, pairsOfCards: 6)
            insertTheme(name: "food", cardsSet: ["🍎", "🍆", "🥕", "🫑", "🧅", "🍅", "🍈", "🍇", "🍍", "🌯", "🍝"], cardColor: .blue, pairsOfCards: 6)
            insertTheme(name: "play", cardsSet: ["⚽️", "🪀", "🎾", "🏋🏻", "🥌", "⛸️", "🎸", "🚣‍♀️"], cardColor: .mint, pairsOfCards: 4)
            insertTheme(name: "mess", cardsSet: ["🍙", "🍰", "🧁", "🍭", "🍝", "🍲", "🥫", "🌮", "🥪", "🧇", "🍈", "🥥", "🍓", "🍋"], cardColor: .orange, pairsOfCards: 7)
        }
    }

    // MARK: - Intent(s)

    // 添加主题(保证唯一id)
    func insertTheme(name themeName: String, cardsSet: [String]? = nil, cardColor: Color, at index: Int = 0, pairsOfCards: Int) -> ThemeChooser.Theme {
        let uniqueID = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1 // 保证id唯一
        let newTheme = Theme(name: themeName, cardsSet: cardsSet ?? [], cardColor: cardColor, id: uniqueID, pairsOfCards: pairsOfCards)
        let safeIndex = min(max(index, 0), themes.count) // 保证index不重复
        themes.insert(newTheme, at: safeIndex)
        return themes[safeIndex]
    }

    // 主题的结构
    struct Theme: Identifiable, Equatable, Hashable {
        var name: String // 主题名称
        var cardsSet: [String] // 卡片集合 (卡片对数可以自己算出来)
        var cardColor: Color // 卡片颜色
        var id: Int // 唯一标识
        var pairsOfCards: Int // 卡片对数

        // 保证只能通过VM来创建主题
        // fileprivate init(name: String, cardsSet: [String], cardColor: Color, pairsOfCards: Int, id: Int) {
        //     self.name = name
        //     self.cardsSet = cardsSet
        //     self.cardColor = cardColor
        //     self.pairsOfCards = pairsOfCards
        //     self.id = id
        // }
    }
}
