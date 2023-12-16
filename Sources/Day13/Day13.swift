import Foundation
import Utilities

func isReflection(at point: Int, in patterns: [String]) -> Bool {
  var left = point - 1
  var right = point
  while left >= 0,
        right < patterns[0].count {
    if patterns.allSatisfy({ p in
      p[left...right] == String(p[left...right].reversed())
    }) {
      left -= 1
      right += 1
    } else {
      return false
    }
  }
  return true
}

func findReflectionPoint(in patterns: [String]) -> Int {
  for i in 1..<patterns[0].count {
    if isReflection(at: i, in: patterns) {
      return i
    }
  }
  return -1
}

func sumPatternNotes(groups: [[String]]) -> Int {
  groups.map {
    let vertical = findReflectionPoint(in: $0)
    let horizontal = findReflectionPoint(in: $0.rotatedLeft())
    if vertical != -1 {
      return vertical
    } else {
      return horizontal * 100
    }
  }.reduce(0, +)
}

func parsePatternGroups(input: String) -> [[String]] {
  let lines = input.components(separatedBy: "\n")
  let groupedLines = lines.split(separator: "", omittingEmptySubsequences: false)
  let result = groupedLines.map { Array($0) }
    .filter { !$0.isEmpty }
    .map { $0.map { String($0) } }
  return result
}

func part1() -> Int {
  let input = readContentsOfFile(named: "Input.txt")!
  let groups = parsePatternGroups(input: input)
  return sumPatternNotes(groups: groups)
}

@main
struct Day13 {
  public static func main() {
    print("Part 1: \(part1())")
  }
}
