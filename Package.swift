// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "VYNFCKit",
  platforms: [
    .iOS(.v11),
    .tvOS(.v10),
    .watchOS(.v3),
    .macOS(.v10_14)
  ],
  products: [
    .library(name: "VYNFCKit", targets: ["VYNFCKit"])
  ],
  targets: [
    .target(name: "VYNFCKit")
  ],
  swiftLanguageVersions: [.v5]
)
