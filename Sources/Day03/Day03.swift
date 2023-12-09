import Foundation
import Utilities

extension Position {
  func boxed() -> Set<Position> {
    return Set([
      Position(row: -1, col: 0),
      Position(row: 1, col: 0),
      Position(row: 0, col: -1),
      Position(row: 0, col: 1),
      Position(row: -1, col: -1),
      Position(row: -1, col: 1),
      Position(row: 1, col: -1),
      Position(row: 1, col: 1)
    ].map { dir in
      Position(row: row, col: col) + dir
    })
  }
}

struct Part: Hashable {
  let value: Int
  let positions: [Position]
  
  func boxed() -> Set<Position> {
    Set(positions.flatMap { pos in
      pos.boxed()
    })
  }
}

struct Symbol: Hashable {
  let type: String
  let position: Position
  
  func boxed() -> Set<Position> {
    position.boxed()
  }
}

func isSymbol(string: String) -> Bool {
  return Int(string) == nil && string != "."
}

func parseParts(input: EnumeratedSequence<[String]>) -> [Part] {
  return input
    .flatMap { line in
      var additionalOffset = 0
      return line.element
        .components(separatedBy: .decimalDigits.inverted)
        .enumerated()
        .compactMap { (offset, element) in
          let baseIndex = additionalOffset + offset
          var part: Part?
          if !element.isEmpty {
            part = Part(
              value: Int(element)!,
              positions: (baseIndex..<baseIndex+element.count)
                .map { .init(row: line.offset, col: $0) }
            )
          }
          additionalOffset += element.count
          return part
        }
    }
}

func parseSymbols(input: EnumeratedSequence<[String]>) -> [Symbol] {
  return input
    .flatMap { line in
      line.element
        .map { Array(arrayLiteral: $0) }
        .enumerated()
        .compactMap { (offset, element) in
          if isSymbol(string: String(element)) {
            return Symbol(
                type: String(element),
                position: .init(
                  row: line.offset,
                  col: offset
                )
              )
          } else {
            return nil
          }
        }
    }
}

func part1() -> Int {
  let input = readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .enumerated()
  
  let parts = parseParts(input: input)
  let symbols = parseSymbols(input: input)
  
  let partsMap = parts.reduce(into: [Part: Int]()) { partial, part in
    partial[part] = part.value
  }
  let symbolPositions = Set(symbols.map { $0.position })
  
  var sum = 0
  for (key, value) in partsMap {
    if !symbolPositions.intersection(key.boxed()).isEmpty {
      sum += value
    }
  }
  
  return sum
}

func part2() -> Int {
  let input = readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .enumerated()
  
  let parts = parseParts(input: input)
  let partsMap = parts.reduce(into: [Part: Int]()) { partial, part in
    partial[part] = part.value
  }
  
  let gearPositions = Set(
    parseSymbols(input: input)
      .filter { $0.type == "*" }
      .map { $0.position }
  )
  
  var result = 0
  for gear in gearPositions {
    let matches = partsMap.keys
      .filter {
        !Set($0.positions).intersection(gear.boxed()).isEmpty
      }
    if matches.count == 2 {
      result += matches.reduce(into: 1) { partial, next in
        partial *= partsMap[next]!
      }
    }
  }
  
  return result
}

@main
struct Day03 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
