import Foundation
import Utilities

func parseInput() -> Grid<String> {
  let contents = readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .map { $0.map { String($0) } }
  return Grid(array: contents)
}

func pushNorth(position: Position, grid: inout Grid<String>) {
  var cursor = position
  while grid[cursor + .north] == "." {
    grid.swapAt(i: cursor, j: cursor + .north)
    cursor = cursor + .north
  }
}

func part1() -> Int {
  var grid = parseInput()
  for col in 0..<grid.colCount {
    for row in 0..<grid.rowCount {
      let position = Position(row: row, col: col)
      if grid[position] == "O" {
        pushNorth(position: position, grid: &grid)
      }
    }
  }
  return grid.filter { $0 == "O" }
    .map { grid.rowCount - $0.row }
    .reduce(0, +)
}

@main
struct Day14 {
  public static func main() {
    print("Part 1: \(part1())")
  }
}
