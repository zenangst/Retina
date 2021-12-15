import ArgumentParser

enum RetinaError: Error {
    case unableToGetCurrentDisplayMode
}

struct Retina: ParsableCommand {
    static let allCommands: String = Command.allCases
        .map { $0.rawValue }
        .joined(separator: ", ")
    @Argument(help: "Run a command, available commands: \(allCommands)")
    var command: Command

    mutating func run() throws {
        let display = try Display()
        switch command {
        case .previous:
            try ToggleCommand.run(for: display, direction: .previous)
        case .next:
            try ToggleCommand.run(for: display, direction: .next)
        case .version:
            VersionCommand.run()
        }
    }

    
}
