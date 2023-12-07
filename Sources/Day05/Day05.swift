import Foundation
import Utilities


struct Map {
  let destinations: [Range<Int>]
  let sources: [Range<Int>]
  
  func mapValue(value: Int) -> Int {
    for i in 0..<destinations.count {
      let destination = destinations[i]
      let source = sources[i]
      if source.contains(value) {
        let offset = value - source.lowerBound
        return destination.lowerBound + offset
      }
    }
    return value
  }
  
  func processRange(range: Range<Int>) -> [Range<Int>] {
    var mappedRanges: [Range<Int>] = []
    for i in 0..<sources.count {
      let source = sources[i]
      let clamped = range.clamped(to: source)
      if !clamped.isEmpty {
        let offset = clamped.lowerBound - source.lowerBound
        let lower = destinations[i].lowerBound + offset
        let upper = destinations[i].lowerBound + offset + clamped.count
        mappedRanges.append(lower..<upper)
      }
    }
    // Fills in ranges that have no source value
    let noSource = excludeSubranges(from: range, excluding: sources)
    mappedRanges.append(contentsOf: noSource)
    return mappedRanges
  }
  
  func mapRanges(ranges: [Range<Int>]) -> [Range<Int>] {
    var result: [Range<Int>] = []
    for r in ranges {
      result.append(contentsOf: processRange(range: r))
    }
    return result
  }
  
  func excludeSubranges(
    from range: Range<Int>,
    excluding subranges: [Range<Int>]
  ) -> [Range<Int>] {
    var resultRanges: [Range<Int>] = []
    var currentStart = range.lowerBound
    
    for subrange in subranges.sorted(by: { $0.lowerBound < $1.lowerBound }) {
      if currentStart < subrange.lowerBound {
        let newRange = currentStart..<subrange.lowerBound
        resultRanges.append(newRange)
        currentStart = subrange.upperBound + 1
      } else {
        currentStart = max(currentStart, subrange.upperBound + 1)
      }
    }
    
    if currentStart <= range.upperBound {
      let finalRange = currentStart..<range.upperBound
      resultRanges.append(finalRange)
    }
    
    return resultRanges
  }
}

func parseMaps(input: [Array<String>.SubSequence]) -> [Map] {
  return input
    .dropFirst()
    .filter { !$0.isEmpty }
    .reduce(into: [Map]()) { partialResult, line in
      let parts = line
        .dropFirst()
        .map {
          $0.split(separator: " ")
            .map { Int($0)! }
        }
      let map = Map(
        destinations: parts.map { ($0[0]..<($0[0] + $0[2])) },
        sources: parts.map { ($0[1]..<($0[1] + $0[2])) }
      )
      partialResult.append(map)
    }
}

func parseSeeds(input: [Array<String>.SubSequence]) -> [Int] {
  return input
    .flatMap { $0 }
    .first!
    .split(separator: " ")
    .compactMap { Int($0) }
}

func part1() -> Int {
  let input = readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .split(separator: "")
  
  let seeds = parseSeeds(input: input)
  let maps = parseMaps(input: input)
  
  var locations = [Int]()
  for seed in seeds {
    var next = seed
    for map in maps {
      next = map.mapValue(value: next)
    }
    locations.append(next)
  }
  
  return locations.min()!
}

func part2() -> Int {
  let input = readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .split(separator: "")
  
  let seeds = parseSeeds(input: input)
  let maps = parseMaps(input: input)
  var mappedRanges = [Range<Int>]()
  let seedRanges = stride(from: 0, to: seeds.count - 1, by: 2).map {
    seeds[$0]..<seeds[$0]+seeds[$0+1]
  }
  
  for r in seedRanges {
    var nextRanges: [Range<Int>] = [r]
    for map in maps {
      nextRanges = map.mapRanges(ranges: nextRanges)
    }
    mappedRanges.append(contentsOf: nextRanges)
  }
  
  let min = mappedRanges.min { $0.lowerBound < $1.lowerBound }!
  return min.lowerBound
}

@main
struct Day05 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
