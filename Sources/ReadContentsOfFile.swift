import Foundation

func readContentsOfFile(named filename: String, fromFile: String = #file) -> String? {
    let currentFileURL = URL(fileURLWithPath: fromFile)
    let directoryURL = currentFileURL.deletingLastPathComponent()
    let fileURL = directoryURL.appendingPathComponent(filename)

    do {
        return try String(contentsOf: fileURL).trimmingCharacters(in: .newlines)
    } catch {
        print("Error: \(error)")
        return nil
    }
}
