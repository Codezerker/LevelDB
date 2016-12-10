import PackageDescription

let package = Package(
    name: "LevelDB",
    dependencies: [
        .Package(url: "https://github.com/Codezerker/Clibleveldb.git", majorVersion: 0),
    ]
)
