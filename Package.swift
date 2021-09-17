// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Retina",
    products: [
        .executable(name: "retina", targets: ["Retina"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser",
                 from: "1.0.1")
    ],
    targets: [
        .executableTarget(name: "Retina", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        .testTarget(name: "RetinaTests", dependencies: ["Retina"]),
    ]
)
