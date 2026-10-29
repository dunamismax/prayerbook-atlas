// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ContentKit",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "ContentKit", targets: ["ContentKit"])
    ],
    targets: [
        .target(name: "ContentKit"),
        .testTarget(name: "ContentKitTests", dependencies: ["ContentKit"]),
    ]
)
