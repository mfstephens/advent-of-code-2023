import Foundation

struct Day04 {
  static func parseInput() -> [[Set<String>]] {
    return readContentsOfFile(named: "Input.txt")!
      .components(separatedBy: .newlines)
      .flatMap {
        $0.split(separator: ":")
          .dropFirst()
          .map { $0.split(separator: "|") }
      }
      .map {
        $0.map {
          $0.components(separatedBy: .decimalDigits.inverted)
            .filter { !$0.isEmpty }
            .reduce(into: Set<String>()) {
              $0.insert($1)
            }
        }
      }
  }
  
  static func part1() -> Int {
    return parseInput()
      .reduce(0) { partial, card in
        let count = card[0].intersection(card[1]).count
        let points = count >= 1 ? Int(pow(2.0, Double(count - 1))) : 0
        return partial + points
      }
  }
  
  static func part2() -> Int {
    let input = parseInput()
    var sum = 0
    for i in 0..<input.count {
      sum += countCopies(index: i, cards: input)
    }
    return sum + input.count
  }
  
  static func countCopies(index: Int, cards: [[Set<String>]]) -> Int {
    let left = cards[index][0]
    let right = cards[index][1]
    var count = left.intersection(right).count
    for i in 0..<count {
      count += countCopies(index: index + 1 + i, cards: cards)
    }
    return count
  }
}
