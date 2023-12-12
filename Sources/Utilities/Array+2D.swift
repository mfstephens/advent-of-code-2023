import Foundation

public extension Array where Element: Collection, Element.Index == Int {
  subscript(pos: Position) -> Element.Element? {
    get {
      guard pos.row >= 0 && pos.row < count else { return nil }
      guard pos.col >= 0 && pos.col < self[pos.row].count else { return nil }
      return self[pos.row][pos.col]
    }
  }
  
  func transposed() -> [[Element.Element]] {
    guard let firstRow = self.first else { return [] }
    let columnCount = firstRow.count
    
    return (0..<columnCount).map { columnIndex in
      self.map { $0[columnIndex] }
    }
  }
  
  func prettyPrinted() {
    for row in self {
      print(row.map { "\($0)" }.joined(separator: ""))
    }
  }
}
