// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ChurchYear",
    platforms: [.iOS(.v26), .macOS(.v26)],
    products: [
        .library(name: "ChurchYear", targets: ["ChurchYear"])
    ],
    targets: [
        .target(name: "ChurchYear"),
        .testTarget(name: "ChurchYearTests", dependencies: ["ChurchYear"]),
    ]
)
