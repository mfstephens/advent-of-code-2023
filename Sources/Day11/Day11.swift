import Foundation
import Utilities

func findGalaxies(input: [[String]]) -> [Position] {
  input
    .enumerated()
    .flatMap { (row, line) in
      line
        .enumerated()
        .compactMap { (col, cell) in
          cell == "#" ? Position(row: row, col: col) : nil
        }
    }
}

func findEmpties(input: [[String]]) -> [Int] {
  input.enumerated().compactMap {
    $0.element.allSatisfy({ $0 == "." }) ? $0.offset : nil
  }
}

func sumDistances(input: [[String]], expansionFactor: Int) -> Int {
  let emptyRows = Set(findEmpties(input: input))
  let emptyCols = Set(findEmpties(input: input.transposed()))
  let galaxies = findGalaxies(input: input)
  let pairs = galaxies
    .enumerated()
    .flatMap { (index, pos) in
      galaxies.dropFirst(index + 1).map { (pos, $0) }
    }
  
  return pairs.map { one, two in
    let rowExpansions = emptyRows.filter {
      let larger = max(one.row, two.row)
      let smaller = min(one.row, two.row)
      return $0 > smaller && $0 < larger
    }.count
    let colExpansions = emptyCols.filter {
      let larger = max(one.col, two.col)
      let smaller = min(one.col, two.col)
      return $0 > smaller && $0 < larger
    }.count

    let a = (abs(one.row - two.row) - rowExpansions) + (rowExpansions * expansionFactor)
    let b = (abs(one.col - two.col) - colExpansions) + (colExpansions * expansionFactor)
    return a + b
  }
  .reduce(0, +)
}

func parseLines() -> [[String]] {
  return readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .map { Array($0.map { String($0) }) }
}

func part1() -> Int {
  let input = parseLines()
  return sumDistances(input: input, expansionFactor: 2)
}

func part2() -> Int {
  let input = parseLines()
  return sumDistances(input: input, expansionFactor: 1000000)
}

@main
struct Day11 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
