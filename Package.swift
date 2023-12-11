// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "advent-of-code-2023",
  platforms: [.macOS(.v14)],
  targets: [
    .executableTarget(name: "Day01", dependencies: ["Utilities"]),
    .executableTarget(name: "Day02", dependencies: ["Utilities"]),
    .executableTarget(name: "Day03", dependencies: ["Utilities"]),
    .executableTarget(name: "Day04", dependencies: ["Utilities"]),
    .executableTarget(name: "Day05", dependencies: ["Utilities"]),
    .executableTarget(name: "Day06", dependencies: ["Utilities"]),
    .executableTarget(name: "Day07", dependencies: ["Utilities"]),
    .executableTarget(name: "Day08", dependencies: ["Utilities"]),
    .executableTarget(name: "Day09", dependencies: ["Utilities"]),
    .executableTarget(name: "Day10", dependencies: ["Utilities"]),
    .target(name: "Utilities", dependencies: []),
  ]
)
