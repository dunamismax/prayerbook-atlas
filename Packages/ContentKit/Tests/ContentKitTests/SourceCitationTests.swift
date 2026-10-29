import Foundation
import Testing

@testable import ContentKit

struct SourceCitationTests {
    /// The stored form is part of the content format (P3.2), so its keys never change.
    @Test func encodesWithStableKeys() throws {
        let citation = SourceCitation(book: .bcp1662, printing: "example-printing", page: "xii")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let json = String(decoding: try encoder.encode(citation), as: UTF8.self)
        #expect(json == #"{"book":"bcp1662","page":"xii","printing":"example-printing"}"#)
        #expect(try JSONDecoder().decode(SourceCitation.self, from: Data(json.utf8)) == citation)
    }
}
