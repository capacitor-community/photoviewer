// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorCommunityPhotoviewer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CapacitorCommunityPhotoviewer",
            targets: ["PhotoViewerPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.20.0"),
        .package(url: "https://github.com/yuriiik/ISVImageScrollView.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "PhotoViewerPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "SDWebImage", package: "SDWebImage"),
                .product(name: "ISVImageScrollView", package: "ISVImageScrollView")
            ],
            path: "ios/Sources/PhotoViewerPlugin"),
        .testTarget(
            name: "PhotoViewerPluginTests",
            dependencies: ["PhotoViewerPlugin"],
            path: "ios/Tests/PhotoViewerPluginTests")
    ]
)
