import Foundation

struct Day02 {
  struct Game {
    let id: Int
    var data: [String: Int] = ["red": 0, "green": 0, "blue": 0]
    var red: Int {
      return data["red"]!
    }
    
    var green: Int {
      return data["green"]!
    }
    
    var blue: Int {
      return data["blue"]!
    }
    
    mutating func updateMax(key: String, value: Int) {
      data[key]! = max(data[key]!, value)
    }
  }
  
  static func parseGames() -> [Game] {
    return readContentsOfFile(named: "Input.txt")!
      .components(separatedBy: .newlines)
      .map { ($0.split(separator: ":")[0], $0.split(separator: ":")[1]) }
      .map {
        let id = Int($0.0.split(separator: " ")[1])!
        return $0.1.split(separator: ";").reduce(into: Game(id: id)) { game, next in
          _ = next.split(separator: ",").map {
            let split = $0.split(separator: " ")
            game.updateMax(key: String(split[1]), value: Int(split[0])!)
          }
        }
      }
  }
  
  static func part1(red: Int, green: Int, blue: Int) -> Int {
    return parseGames()
      .reduce(0) {
        if $1.red <= red, $1.green <= green, $1.blue <= blue {
          return $0 + $1.id
        }
        return $0
      }
  }
  
  static func part2() -> Int {
    return parseGames()
      .reduce(0) {
        $0 + ($1.red * $1.green * $1.blue)
      }
  }
}
