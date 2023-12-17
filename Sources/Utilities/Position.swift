import Foundation

public struct Position: Hashable {
  public let row, col: Int
  
  public init(row: Int, col: Int) {
    self.row = row
    self.col = col
  }
  
  public static func +(lhs: Position, rhs: Position) -> Position {
    return .init(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
  }
}

public extension Position {
  static let north = Position(row: -1, col: 0)
  static let south = Position(row: 1, col: 0)
  static let east = Position(row: 0, col: 1)
  static let west = Position(row: 0, col: -1)
  static let allDirections = [north, south, east, west]
}
