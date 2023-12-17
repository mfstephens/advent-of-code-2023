import Foundation
import Utilities

enum Direction: CaseIterable {
  case north, west, south, east
  
  var nextPosition: Position {
    switch self {
    case .north:
      return .north
    case .west:
      return .west
    case .south:
      return .south
    case .east:
      return .east
    }
  }
}

extension Grid where T == String {
  mutating func shiftItem(atRow row: Int, col: Int, inDirection direction: Direction) {
    var cursor = Position(row: row, col: col)
    while self[cursor + direction.nextPosition] == ".", self[cursor] == "O" {
      swapAt(i: cursor, j: cursor + direction.nextPosition)
      cursor = cursor + direction.nextPosition
    }
  }
  
  mutating func tilt(inDirection direction: Direction) {
    switch direction {
    case .north, .west:
      for row in 0..<rowCount {
        for col in (0..<self[row]!.count) {
          shiftItem(atRow: row, col: col, inDirection: direction)
        }
      }
    case .south, .east:
      for row in (0..<rowCount).reversed() {
        for col in (0..<self[row]!.count).reversed() {
          shiftItem(atRow: row, col: col, inDirection: direction)
        }
      }
    }
  }
}

func parseInput() -> Grid<String> {
  let contents = readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .map { $0.map { String($0) } }
  return Grid(array: contents)
}

func sum(grid: Grid<String>) -> Int {
  grid.filter { $0 == "O" }
    .map { grid.rowCount - $0.row }
    .reduce(0, +)
}

func part1() -> Int {
  var grid = parseInput()
  grid.tilt(inDirection: .north)
  return sum(grid: grid)
}

func runCycle(grid: inout Grid<String>) {
  for dir in Direction.allCases {
    grid.tilt(inDirection: dir)
  }
}

let TotalCycles = 1000000000

func part2() -> Int {
  var grid = parseInput()
  var allCycles = [Grid<String>]()
  for i in 0..<TotalCycles {
    runCycle(grid: &grid)
    if let index = allCycles.lastIndex(of: grid) {
      let loopLength = allCycles[index..<i].count
      let remaining = ((TotalCycles - i) % loopLength) - 1
      for _ in 0..<remaining {
        runCycle(grid: &grid)
      }
      return sum(grid: grid)
    }
    allCycles.append(grid)
  }
  return 0
}

@main
struct Day14 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
