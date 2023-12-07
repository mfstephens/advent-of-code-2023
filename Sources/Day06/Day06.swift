import Foundation
import Utilities

struct Race {
  let time, distance: Int
}

func parseRaces(ignoringSpaces: Bool = false) -> [Race] {
  let input = readContentsOfFile(named: "Input.txt")!
  
  let rows = input.components(separatedBy: .newlines)
    .map { row -> [Int] in
      let components = row
        .components(separatedBy: .decimalDigits.inverted)
        .filter { !$0.isEmpty }
      return ignoringSpaces
      ? [Int(components.joined())!]
      : components.compactMap { Int($0) }
    }
  
  return zip(rows[0], rows[1])
    .map { .init(time: $0.0, distance: $0.1) }
}

func countWins(races: [Race]) -> Int {
  races
    .map { race in
      (0...race.time).filter {
        ($0 * (race.time - $0)) > race.distance
      }
    }
    .map { $0.count }
    .reduce(1, *)
}

func part1() -> Int {
  countWins(
    races: parseRaces()
  )
}

func part2() -> Int {
  countWins(
    races: parseRaces(
      ignoringSpaces: true
    )
  )
}

@main
struct Day06 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
