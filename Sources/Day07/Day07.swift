import Foundation

struct Day07 {
  enum Card: Int, Comparable {
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king, ace
    
    init?(string: String) {
      switch string {
        case "A": self = .ace
        case "K": self = .king
        case "Q": self = .queen
        case "J": self = .jack
        case "T": self = .ten
        case "9": self = .nine
        case "8": self = .eight
        case "7": self = .seven
        case "6": self = .six
        case "5": self = .five
        case "4": self = .four
        case "3": self = .three
        case "2": self = .two
        default: return nil
      }
    }
    
    static func < (lhs: Card, rhs: Card) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
  }
  
  enum HandType: Int, Comparable {
    case highCard // 1, 1, 1, 1, 1
    case onePair // 1, 1, 1, 2
    case twoPair // 1, 2, 2
    case threeOfAKind // 1, 1, 3
    case fullHouse // 2, 3
    case fourOfAKind // 1, 4
    case fiveOfAKind // 5
    
    static func < (lhs: HandType, rhs: HandType) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
  }
  
  static func getHandType(cards: [Card]) -> HandType {
    let pattern = cards
      .reduce(into: [Card: Int]()) { partial, next in
        partial[next, default: 0] += 1
      }
      .values
      .sorted()
    
    switch pattern {
    case [1, 1, 1, 1, 1]:
      return .highCard
    case [1, 1, 1, 2]:
      return .onePair
    case [1, 2, 2]:
      return .twoPair
    case [1, 1, 3]:
      return .threeOfAKind
    case [2, 3]:
      return .fullHouse
    case [1, 4]:
      return .fourOfAKind
    case [5]:
      return .fiveOfAKind
    default:
      fatalError()
    }
  }
  
  struct Hand: Comparable {
    let cards: [Card]
    let bet: Int
    
    static func < (lhs: Hand, rhs: Hand) -> Bool {
      let lhsType = getHandType(cards: lhs.cards)
      let rhsType = getHandType(cards: rhs.cards)
      if lhsType == rhsType {
        for (lhsCard, rhsCard) in zip(lhs.cards, rhs.cards) {
          if lhsCard != rhsCard {
            return lhsCard < rhsCard
          }
        }
        return false
      }
      return lhsType < rhsType
    }
  }
  
  static func parseHands(input: [String]) -> [Hand] {
    input
      .map {
        let split = $0.split(separator: " ")
        return (
          split.first!.map { Card(string: String($0))! },
          Int(split.last!)!
        )
      }
      .map { .init(cards: $0, bet: $1) }
  }
  
  static func readInput() -> [String] {
    return readContentsOfFile(named: "Input.txt")!
      .components(separatedBy: .newlines)
  }
  
  static func part1() -> Int {
    parseHands(input: readInput())
      .sorted(by: <)
      .enumerated()
      .reduce(0) { partial, next in
        partial + (next.element.bet * (next.offset + 1))
      }
  }
}
