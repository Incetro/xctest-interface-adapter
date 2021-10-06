// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "xctest-interface-adapter",
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
