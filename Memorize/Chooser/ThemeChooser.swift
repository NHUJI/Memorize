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
            // 每次修改后自动保存数据
            storeInUserDefaults()
        }
    }

    // 存储,读取相关 包括key(userDefaultsKey)和存储函数(storeInUserDefaults, restoreFromUserDefaults)
    // 用于存储数据的key
    private var userDefaultsKey: String { "ThemeStore:\(name)" }
    // 存储themes
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }

    // 读取themes
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData)
        {
            themes = decodedThemes
        }
    }

    // 初始化
    init(name: String) {
        self.name = name
        // 读取数据
        restoreFromUserDefaults()
        if themes.isEmpty {
            print("使用内置主题 using built-in themes")
            _ = insertTheme(name: "car", cardsSet: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚛", "🛺"], cardColor: RGBAColor(red: 0, green: 0, blue: 1, alpha: 1), pairsOfCards: 6)
            _ = insertTheme(name: "food", cardsSet: ["🍎", "🍆", "🥕", "🫑", "🧅", "🍅", "🍈", "🍇", "🍍", "🌯", "🍝"], cardColor: RGBAColor(red: 0, green: 1, blue: 0, alpha: 1), pairsOfCards: 6)
            _ = insertTheme(name: "play", cardsSet: ["⚽️", "🪀", "🎾", "🏋🏻", "🥌", "⛸️", "🎸", "🚣‍♀️"], cardColor: RGBAColor(red: 1.00, green: 0.753, blue: 0.796, alpha: 1), pairsOfCards: 4)
            _ = insertTheme(name: "mess", cardsSet: ["🍙", "🍰", "🧁", "🍭", "🍝", "🍲", "🥫", "🌮", "🥪", "🧇", "🍈", "🥥", "🍓", "🍋"], cardColor: RGBAColor(red: 1, green: 0, blue: 0, alpha: 1), pairsOfCards: 7)
        } else {
//            print("使用存储主题 using stored themes from UserDefaults: \(themes)")
        }
    }

    // MARK: - Intent(s)

    // 添加主题(保证唯一id)
    func insertTheme(name themeName: String, cardsSet: [String]? = nil, cardColor: RGBAColor, at index: Int = 0, pairsOfCards: Int) -> ThemeChooser.Theme {
        let uniqueID = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1 // 保证id唯一
        let newTheme = Theme(name: themeName, cardsSet: cardsSet ?? [], cardColor: cardColor, id: uniqueID, pairsOfCards: pairsOfCards)
        let safeIndex = min(max(index, 0), themes.count) // 保证index不重复
        themes.insert(newTheme, at: safeIndex)
        return themes[safeIndex]
    }

    // 主题的结构
    struct Theme: Identifiable, Equatable, Hashable, Codable {
        var name: String // 主题名称
        var cardsSet: [String] // 卡片集合 (卡片对数可以自己算出来)
        var cardColor: RGBAColor // 卡片颜色
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
