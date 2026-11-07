// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CherryPicker",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "CherryPicker", targets: ["CherryPicker"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "CherryPicker",
            dependencies: [],
            path: "Sources/CherryPicker"
        )
    ]
)
