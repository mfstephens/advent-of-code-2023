import Foundation

struct Day04 {
  static func part1() -> Int {
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
      .reduce(0) { partial, card in
        let count = card[0].intersection(card[1]).count
        let value = count >= 1 ? Int(pow(2.0, Double(count - 1))) : 0
        return partial + value
      }
  }
}
