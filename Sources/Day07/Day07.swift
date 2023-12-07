import Foundation
import Utilities

enum Card: Int, Comparable {
  case jack, two, three, four, five, six, seven, eight, nine, ten
  case queen, king, ace
  
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
  
  init?(pattern: [Int]) {
    switch pattern {
    case [1, 1, 1, 1, 1]: self = .highCard
    case [1, 1, 1, 2]: self = .onePair
    case [1, 2, 2]: self = .twoPair
    case [1, 1, 3]: self = .threeOfAKind
    case [2, 3]: self = .fullHouse
    case [1, 4]: self = .fourOfAKind
    case [5]: self = .fiveOfAKind
    default: return nil
    }
  }
  
  static func < (lhs: HandType, rhs: HandType) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

func getHandType(cards: [Card]) -> HandType {
  // edge case
  if cards == Array(repeating: Card.jack, count: 5) {
    return .fiveOfAKind
  }
  
  var cardCounts = cards
    .reduce(into: [Card: Int]()) { partial, next in
      partial[next, default: 0] += 1
    }
  
  let jacks = cardCounts.removeValue(forKey: .jack)
  let max = cardCounts.max(by: { ($0.value < $1.value) })
  cardCounts[max!.key]! += jacks ?? 0
  
  let pattern = cardCounts
    .values
    .sorted()
  
  return HandType(pattern: pattern)!
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

func parseHands(input: [String]) -> [Hand] {
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

func readInput() -> [String] {
  return readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
}

func part2() -> Int {
  parseHands(input: readInput())
    .sorted(by: <)
    .enumerated()
    .reduce(0) { partial, next in
      partial + (next.element.bet * (next.offset + 1))
    }
}

@main
struct Day07 {
  public static func main() {
    print("Part 2: \(part2())")
  }
}
