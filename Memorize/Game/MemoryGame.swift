//
//  MemoryGame.swift
//  Memorize
//
//  Created by huhu on 2022/11/20.
//
//  MVVM的model部分,用于存储数据

// Foundation 包括数组字典等基础结构
import Foundation
import SwiftUI

// <CardContent>:使用泛型增加扩展性,比如卡片可以接受图片、String和更多类型的数据作为卡面,并且CardContent类型要求可以进行比较
struct MemoryGame<CardContent>: Codable where CardContent: Equatable, CardContent: Codable {
    typealias Theme = ThemeChooser.Theme // 给Theme结构加上别名,减少去掉本身结构后的修改
    private(set) var cards: [Card]
    private(set) var theme: Theme
    private(set) var score: Int

    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }

    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           // 如果已经向上或配对的卡片被点击无效
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            // 卡片成功配对
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score = score+2
                } else {
                    // 配对失败的话只要有一张之前被翻开过就扣分
                    if cards[chosenIndex].isChosen == true || cards[potentialMatchIndex].isChosen == true {
                        score = score - 1
                    }
                }
                cards[chosenIndex].isChosen = true
                cards[potentialMatchIndex].isChosen = true
                cards[chosenIndex].isFaceUp = true
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }

    // 需要卡片对数量和一个可以给int然后得到卡片内容的函数
    init(theme chosenTheme: Theme, creatCardContent: (Int) -> CardContent) {
        theme = chosenTheme
        cards = [Card]()
        // 随机给予卡片对数,但会导致和新创建的卡片id不一样 失去收回的动画
        let randomIdAdder = Int.random(in: 100 ... 2000)
//        let randomIdAdder = 0
//        let numberOfPairsOfCards = Int.random(in: 1..<chosenTheme.pairsOfCards+1)
        let numberOfPairsOfCards = chosenTheme.pairsOfCards
        // 添加numberOfPairsOfCards 2倍的卡片到数组
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = creatCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2+randomIdAdder))
            cards.append(Card(content: content, id: pairIndex*2+1+randomIdAdder))
        }
        // 将创建的卡片打乱
        cards.shuffle() // 与shuffled不同
        score = 0
    }

    mutating func shuffle() {
        cards.shuffle()
    }

    struct Card: Identifiable, Codable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }

        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }

        var isChosen = false
        let content: CardContent
        let id: Int

        // MARK: - Bonus Time

        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up

        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6

        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate {
                return pastFaceUpTime+Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0

        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }

        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }

        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}

extension Array {
    // 不指定类型
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}
