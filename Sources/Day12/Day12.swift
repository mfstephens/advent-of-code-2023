import Foundation
import Utilities

// ???.### 1,1,3
// .??..??...?##. 1,1,3
// ?#?#?#?#?#?#?#? 1,3,1,6
// ????.#...#... 4,1,1
// ????.######..#####. 1,6,5
// ?###???????? 3,2,1

struct CacheKey: Hashable {
  let index: Int
  let groupsCount: Int
}

func canFill(springs: [String], groupLength: Int, startIndex: Int) -> Bool {
  guard groupLength + startIndex <= springs.count else {
    return false
  }
  
  // Make sure we aren't next to another group
  if startIndex != 0, springs[startIndex - 1] == "#" {
    return false
  }
  
  // Make sure we aren't hitting a . in the group
  for i in 0..<groupLength {
    if springs[startIndex + i] == "." {
      return false
    }
  }
  
  // Make sure we aren't next to another group
  let groupEnd = groupLength + startIndex
  if groupEnd != springs.count, springs[groupEnd] == "#" {
    return false
  }
  
  return true
}

func countArrangementsCached(springs: [String], groups: [Int], cache: inout [CacheKey: Int], index: Int) -> Int {
  if groups.count == 0 {
    if index < springs.count {
      for i in index..<springs.count {
        if springs[i] == "#" {
          return 0
        }
      } 
    }
    return 1
  }
  
  var newIndex = index
  while newIndex < springs.count, springs[newIndex] == "." {
    newIndex += 1
  }
  
  if newIndex >= springs.count {
    return 0
  }
  
  let cacheKey = CacheKey(index: newIndex, groupsCount: groups.count)
  if let cachedResult = cache[cacheKey] {
    return cachedResult
  }
  
  var result = 0
  
  if canFill(springs: springs, groupLength: groups[0], startIndex: newIndex) {
    let newGroups = Array(groups.dropFirst())
    let groupLength = groups[0]
    result += countArrangementsCached(
      springs: springs,
      groups: newGroups,
      cache: &cache,
      index: newIndex + groupLength + 1
    )
  }
  
  if springs[newIndex] == "?" {
    result += countArrangementsCached(
      springs: springs,
      groups: groups,
      cache: &cache,
      index: newIndex + 1
    )
  }
  
  cache[cacheKey] = result
  return result
}

struct InputLine {
  var springs: [String]
  var groups: [Int]
}

func parseInput() -> [InputLine] {
  readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .map { $0.split(separator: " ") }
    .map {(
      $0[0].map { String($0) },
      $0[1].components(separatedBy: .decimalDigits.inverted)
        .map { Int($0)! }
    )}
    .map {
      InputLine(springs: $0, groups: $1)
    }
}

func sumInput(input: [InputLine]) -> Int {
  input.map { line in
    var cache = [CacheKey: Int]()
    let result = countArrangementsCached(
      springs: line.springs,
      groups: line.groups,
      cache: &cache,
      index: 0
    )
    return result
  }.reduce(0, +)
}

func expandInput(input: [InputLine]) -> [InputLine] {
  input.map {
    let springs = Array(repeating: $0.springs, count: 5)
      .joined(separator: ["?"])
    let groups = Array(repeating: $0.groups, count: 5)
      .flatMap { $0 }
    return InputLine(springs: Array(springs), groups: groups)
  }
}

func part1() -> Int {
  let input = parseInput()
  return sumInput(input: input)
}

func part2() -> Int {
  let input = parseInput()
  return sumInput(input: expandInput(input: input))
}

@main
struct Day12 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
