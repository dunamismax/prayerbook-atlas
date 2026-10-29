// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ScriptureKit",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "ScriptureKit", targets: ["ScriptureKit"])
    ],
    targets: [
        .target(name: "ScriptureKit"),
        .testTarget(name: "ScriptureKitTests", dependencies: ["ScriptureKit"]),
    ]
)
