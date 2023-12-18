import Foundation

public extension Dictionary {
  func prettyPrinted() {
    for (key, value) in self {
      print("\(key): \(value)")
    }
  }
}
