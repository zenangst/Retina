import ArgumentParser

enum Command: String, CaseIterable, ExpressibleByArgument {
    case toggle
    case version

    init?(argument: String) {
        self.init(rawValue: argument)
    }
}
