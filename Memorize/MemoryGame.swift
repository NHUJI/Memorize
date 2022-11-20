//
//  MemoryGame.swift
//  Memorize
//
//  Created by huhu on 2022/11/20.
//
//MVVM的model部分,用于存储数据

//Foundation 包括数组字典等基础结构
import Foundation
//<CardContent>:使用泛型增加扩展性,比如卡片可以接受图片、String和更多类型的数据作为卡面
struct MemoryGame<CardContent>{
    private(set) var cards: Array<Card>
    //需要卡片对数量和一个可以给int然后得到卡片内容的函数
    init(numberOfPairsOfCards: Int, creatCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        // 添加numberOfPairsOfCards 2倍的卡片到数组
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = creatCardContent(pairIndex)
            cards.append(Card(content: content,id: pairIndex*2))
            cards.append(Card(content: content,id: pairIndex*2+1))
        }
    }
    
    //函数 名字(标签:类型)
    mutating func choose(_ card: Card){
        let chosenIndex = index(of: card)
        //.toggle()和“= !isFaceUp”效果相同
        cards[chosenIndex].isFaceUp.toggle()
        //调试语句
        print("\(cards)")
    }
    
    func index(of: Card) -> Int {
        for index in 0..<cards.count {
            if cards[index].id == of.id {
                return index
            }
        }
        //这里有一点小问题
        return 0
    }
    
    //之所以放在里面可以表明它是MemoryGame的card,并且有可以识别的不同卡片的id
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
