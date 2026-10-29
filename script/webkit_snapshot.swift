// Snapshots a page with WebKit, Safari's engine, from the command line, for
// browser checks without driving Safari itself (BUILD.md P2.4, P21.5).
//
//   swiftc -O script/webkit_snapshot.swift -o tmp/webkit_snapshot
//   tmp/webkit_snapshot http://localhost:3000/dev/type tmp/screenshots/webkit.png 1440 2400 light
//
// The image goes wherever you say; keep it under tmp/, which is never committed.

import AppKit
import WebKit

let args = CommandLine.arguments
let url = URL(string: args[1])!, out = args[2]
let width = Double(args[3])!, height = Double(args[4])!
let app = NSApplication.shared
app.appearance = NSAppearance(named: args[5] == "dark" ? .darkAqua : .aqua)

final class Delegate: NSObject, WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      let config = WKSnapshotConfiguration()
      webView.takeSnapshot(with: config) { image, error in
        guard let image, let tiff = image.tiffRepresentation,
              let png = NSBitmapImageRep(data: tiff)?.representation(using: .png, properties: [:]) else {
          print("snapshot failed: \(String(describing: error))"); exit(1)
        }
        try! png.write(to: URL(fileURLWithPath: out)); print("wrote \(out)"); exit(0)
      }
    }
  }
}

let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: width, height: height), styleMask: [.borderless], backing: .buffered, defer: false)
let webView = WKWebView(frame: window.contentView!.bounds)
webView.appearance = app.appearance
window.contentView!.addSubview(webView)
let delegate = Delegate()
webView.navigationDelegate = delegate
webView.load(URLRequest(url: url))
DispatchQueue.main.asyncAfter(deadline: .now() + 20) { print("timeout"); exit(2) }
app.run()
