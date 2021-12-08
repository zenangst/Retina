var arguments = Array(CommandLine.arguments.reversed())
_ = arguments.popLast()

if arguments.isEmpty {
    arguments.append(Command.toggle.rawValue)
}

Retina.main(arguments)
