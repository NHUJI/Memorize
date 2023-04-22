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
    @State private var isShowingThemeEditor = false // 是否显示主题编辑器
    // 用于返回按钮,一般不会自己创建相关的本地变量
    @Environment(\.presentationMode) var presentationMode
   
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
                        }
                        HStack {
                            if theme.pairsOfCards == theme.cardsSet.count {
                                Text("All cards")
                            } else {
                                Text("\(theme.pairsOfCards) pairs")
                                Text(theme.cardsSet.prefix(8).joined(separator: "") + (theme.cardsSet.count > 8 ? " ..." : "")) // 将数组中的元素拼接成字符串
                                Spacer()
                            }
                        }
                    }

                    .gesture(editMode == .active ? openThemeEditorTap(for: theme) : nil)
                }
                .onDelete { indexSet in
                    themes.themes.remove(atOffsets: indexSet) // 删除 (使用数组的remove方法)
                }
                .onMove { indexSet, newOffset in // 移动
                    themes.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Memorize") // 列表标题
            // 这里的for似乎要放NavigationLink发送来接收的类型才行
            .navigationDestination(for: ThemeChooser.Theme.self) { theme in
//                ThemeEditor(theme: $themes.themes[theme])
                EmojiMemoryGameView(game: EmojiMemoryGame(chosenTheme: theme))
            }
            .toolbar {
                ToolbarItem { EditButton() } // 用于编辑模式切换按钮(swiftUI自带)
                // TODO: 左边放添加主题的按扭
            }
            .environment(\.editMode, $editMode) // 使用了绑定来修改和显示编辑模式
            // .sheet(isPresented: $isShowingThemeEditor) {
            //     ThemeEditor(theme: selectedTheme)
            // }
//            .sheet(isPresented: $isShowingThemeEditor) {
//                // ThemeEditor(theme: $themes.themes.first(where: { $0.id == selectedThemeId }))
//                // 如果theme存在就显示,否则就显示空白
//                if let theme = themes.themes.first(where: { $0.id == selectedThemeId }) {
//                    ThemeEditor(theme: $themes.themes[theme])
//                } else {
//                    Text("没有找到\(selectedThemeId)")
//                }
//            }
        }
    }

    
    // func openThemeEditorTap(for theme: ThemeChooser.Theme) -> some Gesture {
    //     TapGesture(count: 1).onEnded { _ in
    //         $selectedThemeId.wrappedValue = theme.id
    //         isShowingThemeEditor = true
    //         print(themes.themes)

    //         selectedTheme = theme
    //     }
    // }
}

struct ThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooserView().environmentObject(ThemeChooser(name: "Preview"))
    }
}
