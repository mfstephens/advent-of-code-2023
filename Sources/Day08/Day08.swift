import Foundation
import Utilities

struct Map {
  var instructions: InstructionList
  let nodes: [String: Node]
  
  func countSteps(from start: String, to end: String) -> Int {
    var instructionsCopy = instructions
    var visitedNodes = Set<VisitedNode>()
    var steps: Int = 0
    var node: String = start
    while node != end {
      let visitedNode = VisitedNode(id: node, instruction: instructionsCopy.index)
      if visitedNodes.contains(visitedNode) {
        return 0
      }
      visitedNodes.insert(visitedNode)
      let instruction = instructionsCopy.next()
      node = nodes[node]![keyPath: instruction]
      steps += 1
    }
    return steps
  }
}

struct VisitedNode: Hashable {
  let id: String
  let instruction: Int
}

struct Node {
  let left, right: String
}

struct InstructionList {
  var instructions: [KeyPath<Node, String>]
  var index = 0
  
  mutating func next() -> KeyPath<Node, String> {
    let r = instructions[index]
    index += 1
    if index >= instructions.count {
      index = 0
    }
    return r
  }
}

func gcd(_ a: Int, _ b: Int) -> Int {
  var num1 = a
  var num2 = b
  while num2 != 0 {
    let temp = num1 % num2
    num1 = num2
    num2 = temp
  }
  return num1
}

func lcm(_ numbers: [Int]) -> Int {
  var result = numbers[0]
  for i in 1..<numbers.count {
    result = (result * numbers[i]) / gcd(result, numbers[i])
  }
  return result
}

func readInput() -> [String]! {
  return readContentsOfFile(named: "Input.txt")!
    .components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
}

func parseInstructions(input: String) -> InstructionList {
  InstructionList(instructions: input.map {
    $0 == "L" ? \Node.left : \Node.right
  })
}

func parseMap(input: [String]) -> Map {
  let instructions = parseInstructions(input: input[0])
  let nodes = input.dropFirst()
    .map {
      $0
        .components(separatedBy: .alphanumerics.inverted)
        .filter { !$0.isEmpty }
    }
    .reduce(into: [String: Node]()) { partial, next in
      partial[next[0]] = Node(left: next[1], right: next[2])
    }
  return Map(instructions: instructions, nodes: nodes)
}

func part1() -> Int {
  let input = readInput()!
  let map = parseMap(input: input)
  return map.countSteps(from: "AAA", to: "ZZZ")
}

func part2() -> Int {
  let input = readInput()!
  let map = parseMap(input: input)
  
  let starts = map.nodes.keys.filter { $0.last == "A" }
  let ends = map.nodes.keys.filter { $0.last == "Z" }
  var branches = [Int]()
  
  for start in starts {
    for end in ends {
      let steps = map.countSteps(from: start, to: end)
      if steps != 0 {
        branches.append(steps)
      }
    }
  }
  
  return lcm(branches)
}

@main
struct Day08 {
  public static func main() {
    print("Part 1: \(part1())")
    print("Part 2: \(part2())")
  }
}
