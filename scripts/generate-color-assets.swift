// Generate the asset catalog's colour sets from design/tokens.json, so the
// two cannot drift (BUILD.md P2.3).
//
//   xcrun swift scripts/generate-color-assets.swift          # write the colour sets
//   xcrun swift scripts/generate-color-assets.swift --check  # fail if they are stale
//
// Every token under "color" becomes Tokens/<name>.colorset and every ribbon
// under "ribbon" becomes Ribbon/ribbon<Name>.colorset, each with a day (any)
// and a night (dark) value. AccentColor is written from rubric. Xcode's
// generated asset symbols then expose them as Color.paper, Color.ribbonViolet,
// and so on. Stale generated colour sets are removed.

import Foundation

let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
let tokensURL = root.appending(path: "design/tokens.json")
let catalogURL = root.appending(path: "App/Resources/Assets.xcassets")
let checkOnly = CommandLine.arguments.contains("--check")

struct Swatch {
    let name: String
    let day: String
    let night: String
}

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data("error: \(message)\n".utf8))
    exit(1)
}

func swatches(in section: String, of tokens: [String: Any], prefix: String = "") -> [Swatch] {
    guard let entries = tokens[section] as? [String: Any] else { fail("tokens.json has no \"\(section)\" section") }
    return entries.keys.sorted().compactMap { key in
        guard let entry = entries[key] as? [String: Any] else { return nil }  // skips "note"
        guard let day = entry["day"] as? String, let night = entry["night"] as? String else {
            fail("\(section).\(key) needs \"day\" and \"night\" values")
        }
        let name = prefix.isEmpty ? key : prefix + key.prefix(1).uppercased() + key.dropFirst()
        return Swatch(name: name, day: day, night: night)
    }
}

func components(_ hex: String) -> [String: String] {
    let digits = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
    guard digits.count == 6, digits.allSatisfy(\.isHexDigit) else { fail("\(hex) is not a #RRGGBB colour") }
    let upper = digits.uppercased()
    func pair(_ offset: Int) -> String {
        let start = upper.index(upper.startIndex, offsetBy: offset)
        return "0x" + upper[start..<upper.index(start, offsetBy: 2)]
    }
    return ["alpha": "1.000", "red": pair(0), "green": pair(2), "blue": pair(4)]
}

func json(_ object: Any) -> Data {
    do {
        var data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys])
        data.append(Data("\n".utf8))
        return data
    } catch {
        fail("could not encode JSON: \(error)")
    }
}

func colorSet(_ swatch: Swatch) -> Data {
    json([
        "colors": [
            ["color": ["color-space": "srgb", "components": components(swatch.day)], "idiom": "universal"],
            [
                "appearances": [["appearance": "luminosity", "value": "dark"]],
                "color": ["color-space": "srgb", "components": components(swatch.night)],
                "idiom": "universal",
            ],
        ],
        "info": ["author": "xcode", "version": 1],
    ])
}

let folderContents = json(["info": ["author": "xcode", "version": 1]])

guard let data = try? Data(contentsOf: tokensURL),
    let tokens = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
else { fail("could not read \(tokensURL.path)") }

let colors = swatches(in: "color", of: tokens)
let ribbons = swatches(in: "ribbon", of: tokens, prefix: "ribbon")
guard let rubric = colors.first(where: { $0.name == "rubric" }) else { fail("tokens.json has no rubric") }

// Every file the generator owns, relative to the asset catalog.
var expected: [String: Data] = [
    "Tokens/Contents.json": folderContents,
    "Ribbon/Contents.json": folderContents,
    "AccentColor.colorset/Contents.json": colorSet(
        Swatch(name: "AccentColor", day: rubric.day, night: rubric.night)
    ),
]
for swatch in colors { expected["Tokens/\(swatch.name).colorset/Contents.json"] = colorSet(swatch) }
for swatch in ribbons { expected["Ribbon/\(swatch.name).colorset/Contents.json"] = colorSet(swatch) }

// Generated colour sets already on disk, to find stale ones.
let fileManager = FileManager.default
var existing: Set<String> = []
for folder in ["Tokens", "Ribbon"] {
    let folderURL = catalogURL.appending(path: folder)
    for name in (try? fileManager.contentsOfDirectory(atPath: folderURL.path)) ?? [] where name.hasSuffix(".colorset") {
        existing.insert("\(folder)/\(name)/Contents.json")
    }
}
let stale = existing.subtracting(expected.keys)
let changed = expected.keys.sorted().filter { path in
    (try? Data(contentsOf: catalogURL.appending(path: path))) != expected[path]
}

if checkOnly {
    if changed.isEmpty && stale.isEmpty {
        print("Colour assets match design/tokens.json")
        exit(0)
    }
    for path in changed { print("out of date: \(path)") }
    for path in stale.sorted() { print("stale: \(path)") }
    fail("colour assets differ from design/tokens.json; run `make tokens`")
}

for path in stale.sorted() {
    try? fileManager.removeItem(at: catalogURL.appending(path: path).deletingLastPathComponent())
    print("removed \(path)")
}
for path in changed {
    let url = catalogURL.appending(path: path)
    do {
        try fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try expected[path]!.write(to: url)
    } catch {
        fail("could not write \(url.path): \(error)")
    }
    print("wrote \(path)")
}
print("\(colors.count) tokens and \(ribbons.count) ribbons generated")
