// swift-tools-version:5.3
import PackageDescription

_ = Package(
    name: "deps",
    platforms: [.macOS("11")],
    dependencies: [
        .package(url: "https://github.com/yury/FMake", from: "0.0.16")
        // .package(path: "../FMake")
    ],
    
    targets: [
        .target(
            name: "build",
            dependencies: ["FMake"]
        ),
    ]
)