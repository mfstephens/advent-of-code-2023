import Foundation
import Utilities

struct Lens {
  let label: String
  let focalLength: Int
}

enum Operation {
  case insert(Int)
  case remove
}

struct Step {
  let label: String
  let operation: Operation
}

func readInput() -> [String] {
  readContentsOfFile(named: "Input.txt")!
    .filter { $0 != "\n" }
    .components(separatedBy: ",")
}

func parseInput(input: [String]) -> [Step] {
  input
    .map {
      let scanner = Scanner(string: $0)
      let label = scanner.scanCharacters(from: .letters)!
      _ = scanner.scanCharacters(from: CharacterSet(charactersIn:"-="))!
      var operation: Operation
      if let focalLength = scanner.scanCharacters(from: .decimalDigits)  {
        operation = .insert(Int(focalLength)!)
      } else {
        operation = .remove
      }
      return Step(label: label, operation: operation)
    }
}

func hash(string: String) -> Int {
  string.reduce(into: 0) {
    $0 += Int($1.asciiValue!)
    $0 *= 17
    $0 = $0 % 256
  }
}

func sumInputHash(input: [String]) -> Int {
  input.map {
    hash(string: $0)
  }.reduce(0, +)
}

func part1() -> Int {
  readInput() |> sumInputHash
}

typealias Boxes = [Int: [Lens]]

func fillBoxes(steps: [Step]) -> Boxes {
  steps.reduce(into: [Int: [Lens]]()) { partial, next in
    let hashed = hash(string: next.label)
    var box = partial[hashed, default: []]
    switch next.operation {
    case let .insert(focalLength):
      let newLens = Lens(label: next.label, focalLength: focalLength)
      if let index = box.firstIndex(where: {
        $0.label == next.label
      }) {
        box[index] = newLens
      } else {
        box.append(newLens)
      }
    case .remove:
      box.removeAll(where: { $0.label == next.label })
    }
    partial[hashed] = box
  }
}

func sumFocusingPower(boxes: Boxes) -> Int {
  boxes.map { key, value in
    value.enumerated().map { lensIndex, lens in
      (key + 1) * (lensIndex + 1) * lens.focalLength
    }.reduce(0, +)
  }.reduce(0, +)
}

func part2() -> Int {
  readInput() |> parseInput |> fillBoxes |> sumFocusingPower
}

@main
struct Day15 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
