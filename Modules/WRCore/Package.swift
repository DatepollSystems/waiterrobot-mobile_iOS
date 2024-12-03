// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "WRCore",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "WRCore",
            targets: ["WRCore"]
        ),
    ],
    dependencies: [
        .package(path: "../SharedUI"),
        .package(url: "https://github.com/DatepollSystems/WaiterRobot-Shared-Android.git", from: "1.6.1"),
    ],
    targets: [
        .target(
            name: "WRCore",
            dependencies: [
                .product(name: "SharedUI", package: "SharedUI"),
                .product(name: "shared", package: "WaiterRobot-Shared-Android"),
            ]
        ),
        .testTarget(
            name: "WRCoreTests",
            dependencies: ["WRCore"]
        ),
    ]
)
