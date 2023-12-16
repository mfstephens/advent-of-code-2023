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

func findReflectionPoint(in patterns: [String]) -> Int? {
  for i in 1..<patterns[0].count {
    if isReflection(at: i, in: patterns) {
      return i
    }
  }
  return nil
}

func findReflectionPointPart2(original: [String], fixed: [String]) -> Int? {
  for i in 1..<original[0].count {
    if !isReflection(at: i, in: original),
       isReflection(at: i, in: fixed) {
      return i
    }
  }
  return nil
}

func sumHelper(pattern: [String]) -> Int {
  if let vertical = findReflectionPoint(in: pattern) {
    return vertical
  } else if let horizontal = findReflectionPoint(in: pattern.rotatedLeft()) {
    return horizontal * 100
  }
  return 0
}

func sumHelperPart2(original: [String], fixed: [String]) -> Int {
  if let vertical = findReflectionPointPart2(original: original, fixed: fixed) {
    return vertical
  } else if let horizontal = findReflectionPointPart2(
    original: original.rotatedLeft(),
    fixed: fixed.rotatedLeft()
  ) {
    return horizontal * 100
  }
  return 0
}

func parsePatternGroups(input: String) -> [[String]] {
  let lines = input.components(separatedBy: "\n")
  let groupedLines = lines.split(separator: "", omittingEmptySubsequences: false)
  let result = groupedLines.map { Array($0) }
    .filter { !$0.isEmpty }
    .map { $0.map { String($0) } }
  return result
}

func toggled(string: String, at index: Int) -> String {
  var strchars = Array(string)
  if strchars[index] == "." {
    strchars[index] = "#"
  } else {
    strchars[index] = "."
  }
  return String(strchars)
}

func part1() -> Int {
  let input = readContentsOfFile(named: "Input.txt")!
  let groups = parsePatternGroups(input: input)
  return groups.map {
    sumHelper(pattern: $0)
  }.reduce(0, +)
}

func part2() -> Int {
  let input = readContentsOfFile(named: "Input.txt")!
  let groups = parsePatternGroups(input: input)
  return groups.map {
    for i in 0..<$0.count {
      for j in 0..<$0[i].count {
        var fixed = $0
        fixed[i] = toggled(string: $0[i], at: j)
        if sumHelperPart2(original: $0, fixed: fixed) != 0 {
          return sumHelperPart2(original: $0, fixed: fixed)
        }
      }
    }
    return 0
  }.reduce(0, +)
}

@main
struct Day13 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
