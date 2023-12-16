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
      print(row.map { "\($0)" }.joined(separator: "\t"))
    }
  }
  
  func rotatedLeft() -> [[Element.Element]] {
    guard !self.isEmpty else { return [] }
    
    let rowCount = self.count
    let columnCount = self[0].count
    
    var rotatedArray: [[Any?]] = [[Any?]](
      repeating: [Any?](repeating: nil, count: rowCount),
      count: columnCount
    )
    
    for i in 0..<rowCount {
      for j in 0..<columnCount {
        rotatedArray[columnCount - 1 - j][i] = self[i][j]
      }
    }
    
    return rotatedArray.compactMap {
      $0.compactMap { ($0 as! Element.Element)
      }
    }
  }
}

public extension Array where Element: StringProtocol {
  func rotatedLeft() -> [String] {
    let twoD = self.map { $0.map { String($0) } }
    let rotatedLeft = twoD.rotatedLeft()
    return rotatedLeft.map { $0.joined() }
  }
  
  func prettyPrinted() {
    for string in self {
      print("\(string)")
    }
  }
}
