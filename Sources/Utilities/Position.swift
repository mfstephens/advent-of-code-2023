import Foundation

struct Position: Hashable {
    let row, col: Int
    
    static func +(lhs: Position, rhs: Position) -> Position {
        return .init(row: lhs.row + rhs.row, col: lhs.col + rhs.col)
    }
}
