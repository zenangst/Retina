import ArgumentParser

enum Command: String, CaseIterable, ExpressibleByArgument {
    case toggle

    init?(argument: String) {
        self.init(rawValue: argument)
    }
}
