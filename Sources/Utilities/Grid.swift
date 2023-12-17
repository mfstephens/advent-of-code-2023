import Foundation

public struct Grid<T> {
  private var array: [[T]]
  
  public var rowCount: Int {
    return array.count
  }
  
  public var colCount: Int {
    return array[0].count
  }
  
  public init(array: [[T]]) {
    self.array = array
  }
  
  public subscript(pos: Position) -> T? {
    get {
      guard pos.row >= 0 && pos.row < array.count else { return nil }
      guard pos.col >= 0 && pos.col < array[pos.row].count else { return nil }
      return array[pos.row][pos.col]
    }
    
    set {
      guard pos.row >= 0 && pos.row < array.count else { return }
      guard pos.col >= 0 && pos.col < array[pos.row].count else { return }
      array[pos.row][pos.col] = newValue!
    }
  }
  
  public subscript(row: Int) -> [T]? {
    get {
      guard row >= 0 && row < array.count else { return nil }
      return array[row]
    }
  }
  
  public mutating func swapAt(i: Position, j: Position) {
    let temp = array[j.row][j.col]
    array[j.row][j.col] = array[i.row][i.col]
    array[i.row][i.col] = temp
  }
  
  public func prettyPrinted() {
    for row in array {
      print(row.map { "\($0)" }.joined(separator: "\t"))
    }
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