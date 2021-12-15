import ArgumentParser

enum Command: String, CaseIterable, ExpressibleByArgument {
    case previous
    case next
    case version

    init?(argument: String) {
        self.init(rawValue: argument)
    }
}
