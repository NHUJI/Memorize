//
//  ThemeEditor.swift
//  Memorize
//
//  Created by huhu on 2023/4/21.
//  编辑主题的视图

import SwiftUI

struct ThemeEditor: View {
//    @Binding var theme: ThemeChooser.Theme
    // 创建一个测试用的model
    @State private var theme: ThemeChooser.Theme = ThemeChooser(name: "test").themes.first!

    var body: some View {
        // Form可以提供类似系统默认的表单样式
        Form {
            nameSection
            removeEmojiSection
            addEmojiSection
            cardCountSection
            colorSection
        }
        .frame(minWidth: 300, minHeight: 350) // 还有很多其他参数,我们只设置了最小宽高
        .navigationTitle("Edit \(theme.name)") // 设置导航栏标题(只在Navigation导航过来时有效)
    }

    // MARK: 表格项

    var nameSection: some View {
        Section(header: Text("THEME NAME").font(.system(.body, design: .rounded)).bold()) {
            TextField("THEME NAME", text: $theme.name)
        }
    }

    var removeEmojiSection: some View {
        Section(header:
            HStack {
                Text("Emojis").font(.system(.body, design: .rounded)).bold()
                Spacer()
                Text("TAP EMOJI TO EXCLUDE")
            }) {
                let emojis = theme.cardsSet.removingDuplicateCharacters.map { String($0) }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .onTapGesture { // 点击表情就删除
                                withAnimation {
                                    theme.cardsSet.removeAll(where: { String($0) == emoji })
                                }
                            }
                    }
                }
                .font(.system(size: 40))
            }
    }

    @State private var emojisToAdd = ""

    var addEmojiSection: some View {
        Section(header: Text("ADD EMOJI").font(.system(.body, design: .rounded)).bold()) {
            //  TextField("ADD EMOJI", text: .constant("placeholder")) // 占位符
            TextField("", text: $emojisToAdd) // 还可以用onCommit{}来在用户回车时提交,还有onEditingChanged{}来监听用户是否正在编辑等
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis) // 每次输入就添加表情
                }
        }
    }

    // 在原有的表情组上添加新的表情
    func addEmojis(_ emojis: String) {
        withAnimation {
            // 分离可能一次性输入的多个表情
            for emoji in emojis {
                theme.cardsSet = (theme.cardsSet + String(emoji)) // 字符转换为字符串
                    .filter { $0.isEmoji } // 确保是表情
                    .removingDuplicateCharacters
            }
        }
    }

    var cardCountSection: some View {
        Section(header: Text("CARD COUNT").font(.system(.body, design: .rounded)).bold()) {
            Text("\(theme.pairsOfCards) pairs")
        }
    }

    var colorSection: some View {
        Section(header: Text("COLOR").font(.system(.body, design: .rounded)).bold()) {
            // TODO: 变成多个颜色可选
            Text($theme.cardColor.wrappedValue.description)
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor()
    }
}
