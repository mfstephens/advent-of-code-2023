import Foundation

public struct Grid<T> {
  var array: [[T]]
  
  public var rowCount: Int {
    return array.count
  }
  
  public var colCount: Int {
    return array[0].count
  }
  
  public init(array: [[T]]) {
    self.array = array
  }
  
  public subscript(row: Int) -> [T]? {
    get {
      guard row >= 0 && row < array.count else { return nil }
      return array[row]
    }
  }
  
  public subscript(row: Int, col: Int) -> T? {
    get {
      guard row >= 0 && row < array.count else { return nil }
      guard col >= 0 && col < array[row].count else { return nil }
      return array[row][col]
    }
    
    set {
      guard row >= 0 && row < array.count else { return }
      guard col >= 0 && col < array[row].count else { return }
      array[row][col] = newValue!
    }
  }
  
  public subscript(pos: Position) -> T? {
    get {
      return self[pos.row, pos.col]
    }
    
    set {
      self[pos.row, pos.col] = newValue!
    }
  }
  
  public mutating func swapAt(i: Position, j: Position) {
    let temp = array[j.row][j.col]
    array[j.row][j.col] = array[i.row][i.col]
    array[i.row][i.col] = temp
  }
  
  public func prettyPrinted() {
    for row in array {
      print(row.map { "\($0)" }.joined(separator: ""))
    }
    print("\n")
  }
  
  public func filter(_ isIncluded: (T) -> Bool) -> Set<Position> {
    let filteredArray = array.enumerated().flatMap { (rowIndex, row) in
      row.enumerated().compactMap { (colIndex, item) in
        if isIncluded(item) {
          return Position(row: rowIndex, col: colIndex)
        } else {
          return nil
        }
      }
    }
    return Set(filteredArray)
  }
}

extension Grid: Equatable where T: Equatable {}
extension Grid: Hashable where T: Hashable {}
