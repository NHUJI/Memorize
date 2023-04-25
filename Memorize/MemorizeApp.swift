//
//  MemorizeApp.swift
//  Memorize
//
//  Created by huhu on 2022/11/15.
//

import SwiftUI

@main
struct MemorizeApp: App {
   let userDefaultsManager = UserDefaultsManager()

   init() {
       userDefaultsManager.deleteThemeArrayFromUserDefaults()
       userDefaultsManager.deleteModelFromUserDefaults()
   }

    var body: some Scene {
        WindowGroup {
            // 主要显示的内容:
//            EmojiMemoryGameView(game: game)

            @State var ThemeChooser = ThemeChooser(name: "Play")
            ThemeChooserView().environmentObject(ThemeChooser)
//            ThemeEditor()
        }
    }
}
