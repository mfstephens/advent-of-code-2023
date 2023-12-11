import Foundation
import Utilities

struct Tile: Equatable, Hashable {
  let symbol: String
  let position: Position
  var connections: [Position]
  let isStart: Bool
}

extension Position {
  static let north = Position(row: -1, col: 0)
  static let south = Position(row: 1, col: 0)
  static let east = Position(row: 0, col: 1)
  static let west = Position(row: 0, col: -1)
  static let allDirections = [north, south, east, west]
}

extension Array where Element: Collection, Element.Index == Int {
  subscript(pos: Position) -> Element.Element? {
    get {
      guard pos.row >= 0 && pos.row < count else { return nil }
      guard pos.col >= 0 && pos.col < self[pos.row].count else { return nil }
      return self[pos.row][pos.col]
    }
  }
}

func parseInput() -> [[String]] {
  readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .map {
      Array($0.map { String($0) })
    }
}

func connections(
    to tile: String,
    at position: Position,
    input: [[String]]
  ) -> [Position] {
  switch tile {
  case "|":
    return [position + .north, position + .south]
  case "-":
    return [position + .east, position + .west]
  case "L":
    return [position + .north, position + .east]
  case "J":
    return [position + .north, position + .west]
  case "7":
    return [position + .south, position + .west]
  case "F":
    return [position + .south, position + .east]
  case "S":
    return Position.allDirections.reduce(into: [Position]()) { partial, dir in
      guard let neighbor = input[position + dir] else { return }
      if connections(
        to: neighbor,
        at: position + dir,
        input: input
      ).contains(position) {
        partial.append(position + dir)
      }
    }
  default:
    return []
  }
}

func connectionType(for position: Position, positions: [Position]) -> String {
  switch positions {
  case [position + .north, position + .south]:
    return "|"
  case [position + .east, position + .west]:
    return "-"
  case [position + .north, position + .east]:
    return "L"
  case [position + .north, position + .west]:
    return "J"
  case [position + .south, position + .west]:
    return "7"
  case [position + .south, position + .east]:
    return "F"
  default: fatalError()
  }
}

typealias Grid = [[Tile]]

func buildGrid(from input: [[String]]) -> Grid {
  input.enumerated()
    .map { row, line in
      line.enumerated()
        .map { col, tile in
          let position = Position(row: row, col: col)
          let connections = connections(
            to: tile,
            at: position,
            input: input
          )
          var symbol = tile
          if tile == "S" {
            symbol = connectionType(for: position, positions: connections)
          }
          return Tile(symbol: symbol, position: position, connections: connections, isStart: tile == "S")
        }
      }
}

func findLoop(in grid: Grid) -> Set<Tile> {
  let start = grid
    .compactMap {
      $0.first { $0.isStart }
    }.first!
  
  var previousTile = start
  var currentTile = grid[start.connections[0]]!
  var loop = Set<Tile>()
  loop.insert(start)
  while !currentTile.isStart {
    loop.insert(currentTile)
    let nextPos = currentTile.connections
      .first { grid[$0] != previousTile }!
    if let nextTile = grid[nextPos] {
      previousTile = currentTile
      currentTile = nextTile
    }
  }
  return loop
}

func part1() -> Int {
  let input = parseInput()
  let grid = buildGrid(from: input)
  let loop = findLoop(in: grid)
  
  return Int(ceil(Double(loop.count)/2))
}

func part2() -> Int {
  let input = parseInput()
  let grid = buildGrid(from: input)
  let loop = findLoop(in: grid)
  
  var total = 0
  for line in grid {
    for tile in line {
      guard !loop.contains(tile) else { continue }

      let rayCast = (tile.position.col..<line.count)
        .map { line[$0] }
      let intersections = loop.intersection(rayCast)
      let sides = intersections
        .filter { $0.symbol == "|" }
      
      let corners = intersections
        .filter {
          $0.symbol == "7" ||
          $0.symbol == "F" ||
          $0.symbol == "L" ||
          $0.symbol == "J"
        }
        .sorted(by: { $0.position.col < $1.position.col })
      
      var cornersIterator = corners.makeIterator()
      var intersectionCount = sides.count
      while let current = cornersIterator.next(),
            let next = cornersIterator.next() {
        switch (current.symbol, next.symbol) {
        case ("F", "J"), ("L", "7"):
          intersectionCount += 1
        case ("L", "J"), ("F", "7"):
          break
        default:
          print("\(current.symbol), \(next.symbol)")
          break
        }
      }
      
      if !intersectionCount.isMultiple(of: 2) {
        total += 1
      }
    }
  }
  return total
}

@main
struct Day10 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
