// Call the App Store Connect API with the owner's API key (docs/release.md).
//
//   xcrun swift scripts/asc.swift GET  /v1/apps?filter[bundleId]=com.prayerbookatlas.app
//   xcrun swift scripts/asc.swift POST /v1/betaGroups '{"data":{...}}'
//
// The key ID, issuer ID, and key path come from the environment (ASC_KEY_ID, ASC_ISSUER_ID,
// ASC_KEY_PATH), which `make` reads from the gitignored Config/Secrets.xcconfig. The .p8 key
// itself never enters the repository. Each request carries a fresh ES256 JSON Web Token valid
// for ten minutes, signed with CryptoKit, so no third-party tool is needed. The response body
// is printed as is; the exit status is 1 for any HTTP status of 400 or above.

import CryptoKit
import Foundation

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data("error: \(message)\n".utf8))
    exit(1)
}

func base64URL(_ data: Data) -> String {
    data.base64EncodedString().replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
}

let environment = ProcessInfo.processInfo.environment
guard let keyID = environment["ASC_KEY_ID"], !keyID.isEmpty,
    let issuerID = environment["ASC_ISSUER_ID"], !issuerID.isEmpty,
    let keyPath = environment["ASC_KEY_PATH"], !keyPath.isEmpty
else { fail("set ASC_KEY_ID, ASC_ISSUER_ID, and ASC_KEY_PATH (Config/Secrets.xcconfig; docs/release.md)") }

let arguments = CommandLine.arguments
guard arguments.count >= 3 else { fail("usage: asc.swift METHOD /v1/path [json-body]") }
let method = arguments[1].uppercased()
let path = arguments[2]
let body = arguments.count > 3 ? Data(arguments[3].utf8) : nil

let pem: String
do {
    pem = try String(contentsOfFile: (keyPath as NSString).expandingTildeInPath, encoding: .utf8)
} catch {
    fail("could not read the key at \(keyPath)")
}
let key: P256.Signing.PrivateKey
do {
    key = try P256.Signing.PrivateKey(pemRepresentation: pem)
} catch {
    fail("the key at \(keyPath) is not a P-256 private key")
}

let now = Int(Date().timeIntervalSince1970)
let header = #"{"alg":"ES256","kid":"\#(keyID)","typ":"JWT"}"#
let claims = #"{"iss":"\#(issuerID)","iat":\#(now),"exp":\#(now + 600),"aud":"appstoreconnect-v1"}"#
let signingInput = base64URL(Data(header.utf8)) + "." + base64URL(Data(claims.utf8))
guard let signature = try? key.signature(for: Data(signingInput.utf8)) else { fail("could not sign the token") }
let token = signingInput + "." + base64URL(signature.rawRepresentation)

guard let url = URL(string: "https://api.appstoreconnect.apple.com" + path) else { fail("bad path \(path)") }
var request = URLRequest(url: url)
request.httpMethod = method
request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
if let body {
    request.httpBody = body
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
}

let semaphore = DispatchSemaphore(value: 0)
nonisolated(unsafe) var status = 0
URLSession.shared.dataTask(with: request) { data, response, error in
    if let error { FileHandle.standardError.write(Data("error: \(error.localizedDescription)\n".utf8)) }
    status = (response as? HTTPURLResponse)?.statusCode ?? 0
    if let data, !data.isEmpty { FileHandle.standardOutput.write(data) }
    print()
    semaphore.signal()
}.resume()
semaphore.wait()
if status == 0 || status >= 400 {
    FileHandle.standardError.write(Data("HTTP \(status)\n".utf8))
    exit(1)
}
