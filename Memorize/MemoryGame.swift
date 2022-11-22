//
//  MemoryGame.swift
//  Memorize
//
//  Created by huhu on 2022/11/20.
//
//MVVM的model部分,用于存储数据

//Foundation 包括数组字典等基础结构
import Foundation
import SwiftUI
//<CardContent>:使用泛型增加扩展性,比如卡片可以接受图片、String和更多类型的数据作为卡面,并且CardContent类型要求可以进行比较
struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    private(set) var theme: Theme
    private(set) var score: Int
   
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
   
    mutating func choose(_ card: Card){
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
           //如果已经向上或配对的卡片被点击无效
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            //卡片成功配对
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score = score + 2
                }else {
                    //配对失败的话只要有一张之前被翻开过就扣分
                    if cards[chosenIndex].isChosen == true || cards[potentialMatchIndex].isChosen == true{
                        score = score - 1
                    }
                }
                cards[chosenIndex].isChosen = true
                cards[potentialMatchIndex].isChosen = true
                indexOfTheOneAndOnlyFaceUpCard = nil
            }else{
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
            cards[chosenIndex].isFaceUp.toggle()
           
        }
    }

    
    //需要卡片对数量和一个可以给int然后得到卡片内容的函数
    init(numberOfPairsOfCards: Int,theme chosenTheme: Theme, creatCardContent: (Int) -> CardContent) {
        theme = chosenTheme
        cards = Array<Card>()
        
        // 添加numberOfPairsOfCards 2倍的卡片到数组
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = creatCardContent(pairIndex)
            cards.append(Card(content: content,id: pairIndex*2))
            cards.append(Card(content: content,id: pairIndex*2+1))
        }
        //将创建的卡片打乱
        cards = cards.shuffled()
        score = 0
    }
    
   
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var isChosen = false
        let content: CardContent
        let id: Int
    }
    
    struct Theme {
        let name: String
        let cardsSet: Array<String>
        let pairsOfCards: Int
        let cardColor: Color
    }
}
