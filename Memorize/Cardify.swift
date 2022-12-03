//
//  Cardify.swift
//  Memorize
//
//  Created by huhu on 2022/12/1.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier {
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    //相当于在不断提供不同数值的下面body的部分来做动画
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue}
    }
    
    var rotation: Double
    
    func body(content: Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }else{
                shape.fill()
            }
            // 由于content跟随isFaceUp在屏幕上出现或者消失,第二张卡isMatched就不会有改变->动画,通过透明度设置解决这个问题
            content
                .opacity(rotation<90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis:(0, 1, 0))
    }
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }

}

//方便调用所以添加rxtension
extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
