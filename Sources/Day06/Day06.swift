import Foundation

struct Day06 {
  struct Race {
    let time, distance: Int
  }
  
  static func parseRaces(ignoringSpaces: Bool = false) -> [Race] {
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
  
  static func countWins(races: [Race]) -> Int {
    races
      .map { race in
        (0...race.time).filter {
          ($0 * (race.time - $0)) > race.distance
        }
      }
      .map { $0.count }
      .reduce(1, *)
  }
  
  static func part1() -> Int {
    countWins(
      races: parseRaces()
    )
  }
  
  static func part2() -> Int {
    countWins(
      races: parseRaces(
        ignoringSpaces: true
      )
    )
  }
}
