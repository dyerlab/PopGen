// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopGen",
    platforms: [ .macOS("14.2"),
                 .iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PopGen",
            targets: ["PopGen"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package( url: "https://github.com/dyerlab/DLMatrix", from: "1.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PopGen",
            dependencies: ["DLMatrix"],
            resources: [
                .copy("Resources/arapat.csv")
            ]),
        .testTarget(
            name: "PopGenTests",
            dependencies: ["PopGen"]),
    ]
)
    
