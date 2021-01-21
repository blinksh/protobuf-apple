// use it from root folder:
// `swift run --package-path xcfs build`

import Foundation
import FMake 

OutputLevel.default = .error

var checksums: [(file: String, value: String)] = []
let schemes = [ "Protobuf-C++" ]

extension Platform {
  var excludedArchs: [Platform.Arch] {
      switch self {
      case .WatchOS: return [.armv7k]
          
      default: return []
      }
  }    
}

let scheme = "Protobuf-C++"
let framework = "Protobuf_C_"
let platforms: [Platform] = Platform.allCases

for type in ["static", "dynamic"] {

    try sh("LANG=en_US.UTF-8 MATCH_O_TYPE=\(type == "static" ? "staticlib" : "mh_dylib") pod install --repo-update")

    try xcxcf(
        dirPath: ".build",
        project: "Pods/Pods",
        scheme: scheme,
        framework: framework,
        platforms: platforms.map { ($0, excludedArchs: $0.excludedArchs) }
    )

    try cd(".build") {
        let zip = "\(framework)-\(type).xcframework.zip"
        try sh("zip -r \(zip) \(framework).xcframework")
        let chksum = try sha(path: zip)
        checksums.append((file: zip, value: chksum))
    }
}

var releaseNotes =
"""
Release notes:

    | File                            | SHA 256                                             |
    | ------------------------------- |:---------------------------------------------------:|
\(checksums.map {
    "    | \($0.file) | \($0.value) |"
}.joined(separator: "\n"))

"""

try write(content: releaseNotes, atPath: ".build/release.md")

