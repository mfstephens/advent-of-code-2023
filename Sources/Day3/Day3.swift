import Foundation

struct Day3 {
    struct PartPosition: Hashable {
        let row: Int
        let cols: Range<Int>
        
        func boxed() -> Set<Position> {
            let directions = [
                Position(row: -1, col: 0),
                Position(row: 1, col: 0),
                Position(row: 0, col: -1),
                Position(row: 0, col: 1),
                Position(row: -1, col: -1),
                Position(row: -1, col: 1),
                Position(row: 1, col: -1),
                Position(row: 1, col: 1)
            ]

            return Set(cols.flatMap { col in
                directions.map { dir in
                    Position(row: row, col: col) + dir
                }
            })
        }
    }
    
    static func isSymbol(string: String) -> Bool {
        return Int(string) == nil && string != "."
    }
    
    static func part1() -> Int {
        let input = readContentsOfFile(named: "Input.txt")!
            .components(separatedBy: .newlines)
            .enumerated()
        
        var partNumbers = input
            .reduce(into: [PartPosition: Int]()) { partial, next in
                var additionalOffset = 0
                next.element
                    .components(separatedBy: .decimalDigits.inverted)
                    .enumerated()
                    .forEach { (offset, element) in
                        let baseIndex = additionalOffset + offset
                        if !element.isEmpty {
                            let pos = PartPosition(
                                row: next.offset,
                                cols: baseIndex..<baseIndex+element.count
                            )
                            partial[pos] = Int(element)!
                        }
                        additionalOffset += element.count
                    }
            }
        
        let symbols = input
            .reduce(into: Set<Position>()) { partial, next in
                next.element
                    .map { Array(arrayLiteral: $0) }
                    .enumerated()
                    .forEach { (offset, element) in
                        if isSymbol(string: String(element)) {
                            partial.insert(
                                .init(
                                    row: next.offset,
                                    col: offset
                                )
                            )
                        }
                    }
            }

        var sum = 0
        for (key, value) in partNumbers {
            if !symbols.intersection(key.boxed()).isEmpty {
                sum += value
            }
        }
        
        return sum
    }
}
