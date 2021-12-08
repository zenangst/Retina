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
        case .toggle:
            try ToggleCommand.run(for: display)
        case .version:
            VersionCommand.run()
        }
    }

    
}
