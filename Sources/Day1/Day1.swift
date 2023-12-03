import Foundation

struct Day1 {
    enum SearchDirection {
        case forward, backward
    }
    
    static let numbers: [String: String] = [
        "zero": "0", "one": "1", "two": "2", "three": "3", "four": "4",
        "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9"
    ]
    
    static func part1() -> Int {
        let input = readContentsOfFile(named: "Input.txt")!
        return input
            .components(separatedBy: .newlines)
            .reduce(0) { (result, next) in
                let first = next.first(where: { $0.isNumber })!
                let last = next.last(where: { $0.isNumber })!
                return result + Int(String(first) + String(last))!
            }
    }
    
    static func part2() -> Int {
        let input = readContentsOfFile(named: "Input.txt")!
        return input
            .components(separatedBy: .newlines)
            .reduce(0) { (result, next) in
                let first = findNumber(line: next, direction: .forward)
                let last = findNumber(line: next, direction: .backward)
                return result + Int(String(first) + String(last))!
            }
    }
    
    static func findNumber(line: String, direction: SearchDirection) -> Int {
        let options: String.CompareOptions = direction == .forward ? [] : .backwards
        let number = numbers
            .flatMap { [$0, $1] }
            .compactMap { str -> (String, String.Index)? in
                guard let index = line.range(of: str, options: options)?.lowerBound else {
                    return nil
                }
                return (str, index)
            }
            .min(by: {
                direction == .forward ? $0.1 < $1.1 : $0.1 > $1.1
            })!.0
        
        return Int(number) ?? Int(numbers[number]!)!
    }
}
