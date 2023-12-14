import Algorithms
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
  
  // Make sure we aren't hitting a . i in the group
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

func countArrangements(in line: [String], matching pattern: [Int]) -> Int {
  let unknowns = line.indices.filter { line[$0] == "?" }
  let knowns = line.filter { $0 == "#" }
  let totalBroken = pattern.reduce(0, +)
  let missingBroken = totalBroken - knowns.count
  var total = 0
  for i in missingBroken..<unknowns.count {
    var base = Array(repeating: "#", count: i)
    let working = Array(repeating: ".", count: unknowns.count - i)
    base.append(contentsOf: working)
    for combo in base.uniquePermutations() {
      var comboIterator = combo.makeIterator()
      var arrangement = line
      unknowns.forEach {
        arrangement[$0] = comboIterator.next()!
      }
      let candidate = arrangement.chunked(by: ==)
        .filter { $0.allSatisfy { $0 == "#" } }
        .map { $0.count }
      if candidate == pattern {
        total += 1
      }
    }
  }
  return total == 0 ? 1 : total
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

func part1() -> Int {
  let input = readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .map { $0.split(separator: " ") }
    .map {(
      $0[0].map { String($0) },
      $0[1].components(separatedBy: .decimalDigits.inverted)
        .map { Int($0)! }
    )}
  
  return input.map { line, groups in
    countArrangements(in: line, matching: groups)
  }.reduce(0, +)
}

func part2() -> Int {
  let input = parseInput()
  let newInput = input.map {
    let springs = Array(repeating: $0.springs, count: 5)
      .joined(separator: ["?"])
    let groups = Array(repeating: $0.groups, count: 5)
      .flatMap { $0 }
    return InputLine(springs: Array(springs), groups: groups)
  }
  
  return newInput.map { line in
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

@main
struct Day12 {
  public static func main() {
    let clock = ContinuousClock()
    let result2 = clock.measure({
      print(part2())
    })
    print("Part 2 time: \(result2)")
  }
}
