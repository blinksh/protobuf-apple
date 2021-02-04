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


let args = ProcessInfo.processInfo.arguments 

let types: [String]

var skipCocoapodsInstall = false

if args.count > 1 && args[1] != "all" {
    types = args[1].components(separatedBy: ",")
    skipCocoapodsInstall = true
} else {
    types = ["static", "dynamic"]
    skipCocoapodsInstall = false
}

for type in types {

    if !skipCocoapodsInstall {
        try sh("LANG=en_US.UTF-8 MATCH_O_TYPE=\(type == "static" ? "staticlib" : "mh_dylib") pod install --repo-update")
    }

    try xcxcf(
        dirPath: ".build",
        project: "Pods/Pods",
        scheme: scheme,
        framework: framework,
        platforms: platforms.map { ($0, excludedArchs: $0.excludedArchs) }
    )

    try cd(".build") {
        let zip = "\(framework)-\(type).xcframework.zip"
        try sh("zip --symlinks -r \(zip) \(framework).xcframework")
        let chksum = try sha(path: zip)
        checksums.append((file: zip, value: chksum))
    }
}

func read(atPath: String) throws -> String {
  try String(contentsOf: URL(fileURLWithPath: atPath)) 
}

var releaseNotes = (try? read(atPath: ".build/release.md")) ?? ""

if releaseNotes.isEmpty {
    releaseNotes = """
    Release notes:

    | File                            | SHA 256                                             |
    | ------------------------------- |:---------------------------------------------------:|
    \(checksums.map {
        "| \($0.file) | \($0.value) |"
    }.joined(separator: "\n"))

    """
} else {
    releaseNotes += """
    \(checksums.map {
        "| \($0.file) | \($0.value) |"
    }.joined(separator: "\n"))

    """
}



try write(content: releaseNotes, atPath: ".build/release.md")

