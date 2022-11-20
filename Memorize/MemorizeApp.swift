//
//  MemorizeApp.swift
//  Memorize
//
//  Created by huhu on 2022/11/15.
//

import SwiftUI

@main
struct MemorizeApp: App {
    //只是个指针,所以可以let
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            //主要显示的内容:
            ContentView(viewMoedl: game)
        }
    }
}
