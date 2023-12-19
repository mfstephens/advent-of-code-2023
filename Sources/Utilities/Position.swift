import Foundation

public struct Position: Hashable {
  public let row, col: Int
  
  public init(row: Int, col: Int) {
    self.row = row
    self.col = col
  }
  
  public static let zero: Self = .init(row: 0, col: 0)
  
  public static func +(lhs: Position, rhs: Position) -> Position {
    return .init(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
  }
  
  public func moved(_ direction: Direction) -> Position {
    switch direction {
    case .north:
      return self + .north
    case .south:
      return self + .south
    case .east:
      return self + .east
    case .west:
      return self + .west
    }
  }
}

public extension Position {
  static let north = Position(row: -1, col: 0)
  static let south = Position(row: 1, col: 0)
  static let east = Position(row: 0, col: 1)
  static let west = Position(row: 0, col: -1)
  static let allDirections = [north, south, east, west]
}
