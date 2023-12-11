import Foundation
import Utilities

struct Tile: Equatable, Hashable {
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
          return Tile(position: position, connections: connections, isStart: tile == "S")
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

func groupByColDifference(of positions: [Position]) -> [[Position]] {
    var result: [[Position]] = []
    var currentGroup: [Position] = []
    
    for position in positions {
        if let lastPosition = currentGroup.last, abs(position.col - lastPosition.col) > 1 {
            result.append(currentGroup)
            currentGroup = []
        }
        currentGroup.append(position)
    }
    
    if !currentGroup.isEmpty {
        result.append(currentGroup)
    }
    
    return result
}

func part2() -> Int {
  let input = parseInput()
  let grid = buildGrid(from: input)
  let loop = findLoop(in: grid)
  
  var total = 0
  for (row, line) in grid.enumerated() {
    let line = line.enumerated().map { Position(row: row, col: $0.offset) }
    let hits = Set(line).intersection(loop.map { $0.position })
    var sorted = hits.sorted(by: { $0.col < $1.col })
    let grouped = groupByColDifference(of: sorted)
    print(grouped.count)
    
    for i in stride(from: 0, to: grouped.count - 1, by: 2) {
      var current: Position
      if grouped[i].count >= 2 {
        current = grouped[i].last!
      } else {
        current = grouped[i].first!
      }
      
      var next: Position
      if grouped[i + 1].count >= 2 {
        next = grouped[i + 1].first!
      } else {
        next = grouped[i + 1].last!
      }
      
      guard i + 1 < grouped.count, (next.col - current.col) > 1 else { continue }
//      print("adding: \(next.col - current.col - 1) from \(current.col) to \(next.col ) ")
      total += next.col - current.col - 1
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
