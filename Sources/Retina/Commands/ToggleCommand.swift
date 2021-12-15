enum ToggleCommandError: Error {
    case unableToFindNewResolution
}

enum ToggleCommand {
    enum Direction {
        case next, previous
    }
    static func run(for display: Display, direction: Direction) throws {
        guard let current = try display.resolutions().first(where: { $0.current }) else {
           throw ToggleCommandError.unableToFindNewResolution
        }
        let validResolutions = try display.resolutions().filter({ !$0.current })

        switch direction {
        case .previous:
            if let previousResolution = validResolutions.last(where: { $0.width < current.width }) {
                Display.activate(previousResolution.mode, for: display.id)
            } else if let lastResolution = validResolutions.last {
                Display.activate(lastResolution.mode, for: display.id)
            }
        case .next:
            if let nextResolution = validResolutions.first(where: { $0.width > current.width }) {
                Display.activate(nextResolution.mode, for: display.id)
            } else if let firstResolution = validResolutions.first {
                Display.activate(firstResolution.mode, for: display.id)
            }
        }

    }
}
