public extension String {
  subscript(randomIndex: Int) -> Character {
    let index = self.index(self.startIndex, offsetBy: randomIndex)
    return self[index]
  }
  
  subscript (r: ClosedRange<Int>) -> String {
    let s = index(startIndex, offsetBy: r.lowerBound)
    let e = index(startIndex, offsetBy: r.upperBound)
    
    return String(self[s...e])
  }
}
