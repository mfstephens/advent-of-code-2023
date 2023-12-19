import Foundation
import Utilities

enum GridItem: Equatable {
  case empty
  case splitter(Splitter)
  case mirror(Mirror)
  case visited
  
  enum Splitter: Character {
    case horizontal = "-"
    case vertical = "|"
  }
  
  enum Mirror: Character {
    case left = "\\"
    case right = "/"
  }
  
  init?(symbol: Character) {
    if let splitter = Splitter(rawValue: symbol) {
      self = .splitter(splitter)
    } else if let mirror = Mirror(rawValue: symbol) {
      self = .mirror(mirror)
    } else if symbol == "." {
      self = .empty
    } else {
      return nil
    }
  }
}

struct Beam: Hashable {
  var heading: Direction
  var position: Position
  
  func reflected(by mirror: GridItem.Mirror) -> Beam {
    switch (heading, mirror) {
    case (.north, .left), (.south, .right):
      return .init(heading: .west, position: position)
    case (.north, .right), (.south, .left):
      return .init(heading: .east, position: position)
    case (.east, .right), (.west, .left):
      return .init(heading: .north, position: position)
    case (.east, .left), (.west, .right):
      return .init(heading: .south, position: position)
    }
  }
  
  func split(by splitter: GridItem.Splitter) -> (Beam, Beam)? {
    switch (splitter, heading) {
    case (.horizontal, .north), (.horizontal, .south),
        (.vertical, .east), (.vertical, .west):
      return (
        .init(heading: heading.perpindicular.0, position: position),
        .init(heading: heading.perpindicular.1, position: position)
      )
    default:
      return nil
    }
  }
}

struct Simulation {
  var grid: Grid<GridItem>
  var beams = [UUID: Beam]()
  var visitedPositions = Set<Position>([])
  var seenBeams = Set<Beam>()
  
  init(grid: Grid<GridItem>) {
    self.grid = grid
  }
  
  func isValidGridPosition(_ position: Position) -> Bool {
    (position.row >= 0 &&
    position.row < grid.rowCount &&
    position.col >= 0 &&
    position.col < grid.colCount)
  }
  
  mutating func advanceBeams() {
    beams.forEach { key, beam in
      let advancedPos = beam.position.moved(beam.heading)
      if isValidGridPosition(advancedPos) {
        beams[key]?.position = advancedPos
      }
    }
  }
  
  mutating func orientBeams() {
    beams.forEach { key, beam in
      switch (grid[beam.position]!) {
      case let (.splitter(splitter)):
        if let splitBeam = beam.split(by: splitter) {
          (beams[key], beams[UUID()]) = splitBeam
        }
      case let (.mirror(mirror)):
        beams[key] = beam.reflected(by: mirror)
      default:
        break
      }
    }
  }
  
  mutating func removeDeadBeams() {
    beams.forEach { key, beam in
      if beam.position.row <= 0 && beam.heading == .north ||
          beam.position.row >= grid.rowCount - 1 && beam.heading == .south ||
          beam.position.col >= grid.colCount - 1 && beam.heading == .east ||
          beam.position.col <= 0 && beam.heading == .west {
        beams.removeValue(forKey: key)
      }
      if seenBeams.contains(beam) {
        beams.removeValue(forKey: key)
      }
    }
  }
  
  mutating func trackVisited() {
    beams.forEach { key, value in
      visitedPositions.insert(value.position)
    }
  }
  
  mutating func trackSeenBeams() {
    beams.forEach { key, value in
      seenBeams.insert(value)
    }
  }

  mutating func start(entryPoint: Position, heading: Direction) -> Int {
    beams[UUID()] = .init(heading: heading, position: entryPoint)
    while !beams.isEmpty {
      advanceBeams()
      trackVisited()
      orientBeams()
      removeDeadBeams()
      trackSeenBeams()
    }
    return visitedPositions.count
  }
  
  mutating func reset() {
    beams = [UUID: Beam]()
    visitedPositions = Set<Position>([])
    seenBeams = Set<Beam>()
  }
}

func readInput() -> [[GridItem]] {
  readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .map { $0.map { .init(symbol: $0)! } }
}

func part1() -> Int {
  var simulation = readInput() |> Grid.init |> Simulation.init
  return simulation.start(entryPoint: .init(row: 0, col: -1), heading: .east)
}

func part2() -> Int {
  var simulation = readInput() |> Grid.init |> Simulation.init
  var totals = [Int]()
  for row in 0..<simulation.grid.rowCount {
    let sim1 = simulation.start(entryPoint: .init(row: row, col: -1), heading: .east)
    simulation.reset()
    let sim2 = simulation.start(entryPoint: .init(row: row, col: simulation.grid.colCount), heading: .west)
    simulation.reset()
    totals.append(contentsOf: [sim1, sim2])
  }
  
  for col in 0..<simulation.grid.colCount {
    let sim1 = simulation.start(entryPoint: .init(row: -1, col: col), heading: .south)
    simulation.reset()
    let sim2 = simulation.start(entryPoint: .init(row: simulation.grid.rowCount, col: col), heading: .north)
    simulation.reset()
    totals.append(contentsOf: [sim1, sim2])
  }
  
  return totals.max()!
}

@main
struct Day16 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 1: \(part2())")
  }
}
