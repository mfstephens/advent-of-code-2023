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
