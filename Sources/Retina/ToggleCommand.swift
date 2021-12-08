enum ToggleCommandError: Error {
    case unableToFindNewResolution
}

enum ToggleCommand {
    static func run(for display: Display) throws {
        guard let newResolution = try display.resolutions().first(where: { !$0.current }) else {
            throw ToggleCommandError.unableToFindNewResolution
        }

        Display.activate(newResolution.mode, for: display.id)
    }
}
