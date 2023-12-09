import Foundation
import Utilities

func parseInput() -> [[Int]] {
  return readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .map {
      $0.components(separatedBy: .whitespaces)
        .filter { !$0.isEmpty }
        .map { Int($0)! }
    }
}

func findNextHistory(history: [Int]) -> Int {
  if history.allSatisfy({ $0 == 0 }) {
    return 0
  }
  let nextHistory = history
    .enumerated()
    .dropLast()
    .reduce(into: [Int]()) { partial, next in
      let (index, value) = next
      let nextValue = history[index + 1]
      partial.append(nextValue - value)
    }
  return nextHistory.last! + findNextHistory(history: nextHistory)
}

func part1() -> Int {
  parseInput()
    .map {
      findNextHistory(history: $0) + $0.last!
    }
    .reduce(0, +)
}

func part2() -> Int {
  parseInput()
    .map { $0.reversed() }
    .map {
      findNextHistory(history: $0) + $0.last!
    }
    .reduce(0, +)
}

@main
struct Day09 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
