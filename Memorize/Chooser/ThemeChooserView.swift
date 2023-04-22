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
    @Environment(\.editMode) var editModeEnvironment
    @State private var isShowingThemeEditor = false // 是否显示主题编辑器
    // 用于返回按钮,一般不会自己创建相关的本地变量
    @Environment(\.presentationMode) var presentationMode
    // 选中的theme
    @State private var selectedTheme: ThemeChooser.Theme?

    @State private var isClicked = false // 测试用,需要删除

    var body: some View {
        NavigationStack {
            List {
                EditButton().listRowInsets(EdgeInsets(top: 0, leading: 300, bottom: 0, trailing: 0))
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
                                if theme.pairsOfCards == theme.cardsSet.count {
                                    Text("All cards")
                                } else {
                                    Text("\(theme.pairsOfCards) pairs")
                                }
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
                ToolbarItem {
                    //  EditButton()
                    Button(action: {
                        isClicked.toggle()
                    }) {
                        Text("Click me")
                            .foregroundColor(isClicked ? .red : .blue)
                    }
                }
//                    Button(editMode == .inactive ? "Edit" : "Done") {
//                        print("EditButton")
//                        switch editMode {
//                        case .inactive:
//                            editMode = .active
//                            print("Edit")
//                        case .active:
//                            editMode = .inactive
//                            print("Done")
//                        case .transient:
//                            editMode = .inactive
//                        default:
//                            break
//                        }
//                    }

                // 用于编辑模式切换按钮(swiftUI自带)
                // TODO: 左边放添加主题的按扭,下面是临时演示代码
                // ToolbarItem(placement: .navigationBarLeading) {
                //    if presentationMode.wrappedValue.isPresented,
                //       UIDevice.current.userInterfaceIdiom != .pad
                //    {
                //        Button("Close") {
                //            presentationMode.wrappedValue.dismiss()
                //        }
                //    }
                // }
            }
//            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, $editMode) // 使用了绑定来修改和显示编辑模式
            .sheet(isPresented: $isShowingThemeEditor) {
                // ThemeEditor(theme: $themes.themes.first!)
//                 ThemeEditor(theme: $themes.themes[selectedTheme!])
                ThemeEditorView(selectedTheme: $selectedTheme, themes: $themes.themes)
            }
//            .onChange(of: editMode) { newValue in
//                print(newValue)
//            }

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

    func openThemeEditorTap(for theme: ThemeChooser.Theme) -> some Gesture {
        TapGesture().onEnded {
            isShowingThemeEditor = true // 开启主题编辑器
            selectedTheme = theme // 选中的主题
        }
    }
}

struct ThemeChooserView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooserView().environmentObject(ThemeChooser(name: "Preview"))
    }
}

struct ThemeEditorView: View {
    @Binding var selectedTheme: ThemeChooser.Theme?
    @Binding var themes: [ThemeChooser.Theme]

    var body: some View {
        ThemeEditor(theme: $themes[selectedTheme!])
    }
}
