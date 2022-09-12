// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "xctest-interface-adapter",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "XCTestInterfaceAdapter",
            targets: [
                "XCTestInterfaceAdapter"
            ]
        )
    ],
    targets: [
        .target(
            name: "XCTestInterfaceAdapter"
        ),
        .testTarget(
            name: "XCTestInterfaceAdapterTests",
            dependencies: [
                "XCTestInterfaceAdapter"
            ]
        ),
    ]
)
