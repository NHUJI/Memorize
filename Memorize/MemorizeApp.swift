//
//  MemorizeApp.swift
//  Memorize
//
//  Created by huhu on 2022/11/15.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            // 主要显示的内容:
//            EmojiMemoryGameView(game: game)
//            ThemeChooserView().environmentObject(ThemeChooser(name: "Play"))
            ThemeEditor()
        }
    }
}
