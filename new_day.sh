#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <day_name>"
    exit 1
fi

# Get file name and new content from arguments
day_name="$1"

# Create a new directory
mkdir "Sources/$day_name"

# Navigate into the new directory
cd "Sources/$day_name" || exit

filecontent=$(cat <<EOF
import Foundation
import Utilities

func part1() -> Int {
  return 0
}

@main
struct $day_name {
  public static func main() {
    print("Part 1: \(part1())")
  }
}

EOF
)

# Create the new day's files
echo "$filecontent" > "$day_name.swift"
touch "Input.txt"

cd ..
cd ..

sources_directory="Sources"

# Get the folder count within the Sources directory
folder_count=$(find "$sources_directory" -mindepth 1 -maxdepth 1 -type d | wc -l | xargs)

# Start building the Package.swift content
{
    echo "// swift-tools-version:5.9"
    echo ""
    echo "import PackageDescription"
    echo ""
    echo "let package = Package("
    echo "  name: \"advent-of-code-2023\","
    echo "  platforms: [.macOS(.v14)],"
    echo "  targets: ["
} > Package.swift

# Generate executable targets based on folders
index=1
for folder in "$sources_directory"/*/; do
  folder_name=$(basename "$folder")
  
  if [ "$folder_name" == "Utilities" ]; then
    echo "    .target(name: \"$folder_name\", dependencies: [])," >> Package.swift
    else
    echo "    .executableTarget(name: \"$folder_name\", dependencies: [\"Utilities\"])," >> Package.swift
    ((index++))
  fi
done

# Close the Package.swift content
echo "  ]" >> Package.swift
echo ")" >> Package.swift

