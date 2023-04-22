//
//  ThemeChooserView.swift
//  Memorize
//
//  Created by huhu on 2023/4/20.
//  View

import SwiftUI

struct ThemeChooserView: View {
    @EnvironmentObject var themes: ThemeChooser // 从环境中获取主题(VM)
    @State private var editMode: EditMode = .inactive // 编辑模式

    var body: some View {
        NavigationStack {
            List {
                ForEach(themes.themes) { theme in
                    NavigationLink(value: theme) {
                        VStack {
                            HStack {
                                Text(theme.name.capitalized) // 首字母大写
                                    .font(.largeTitle)
                                    .foregroundColor(theme.cardColor)
                                Spacer() // 使用它把名字推到最左边
                            }
                            HStack {
                                // TODO: 之后这里需要根据数据判断选择这个主题需要的卡片数量
                                Text("\(theme.cardsSet.count) pairs")
                                Text(theme.cardsSet.prefix(8).joined(separator: "") + (theme.cardsSet.count > 8 ? " ..." : "")) // 将数组中的元素拼接成字符串
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Memorize") // 列表标题
            // 这里的for似乎要放NavigationLink发送来接收的类型才行
            .navigationDestination(for: ThemeChooser.Theme.self) { _ in
//                EmojiMemoryGameView(game: EmojiMemoryGame(chosenTheme: theme))
                ThemeEditor()
            }
        }
    }
}

struct ThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooserView().environmentObject(ThemeChooser(name: "Preview"))
    }
}
