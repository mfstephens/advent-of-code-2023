import Foundation

struct Day05 {
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
  }
  
  static func parseMaps(input: [Array<String>.SubSequence]) -> [Map] {
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
  
  static func part1() -> Int {
    let input = readContentsOfFile(named: "Input.txt")!
      .components(separatedBy: .newlines)
      .split(separator: "")
      
    let seeds = input
      .flatMap { $0 }
      .first!
      .split(separator: " ")
      .compactMap { Int($0) }
    
    let maps = parseMaps(input: input)
    
    var locations = [Int]()
    for seed in seeds {
      var next = seed
      for map in maps {
        next = map.mapValue(value: next)
        print(next)
      }
      locations.append(next)
    }
    
    return locations.min()!
  }
}

