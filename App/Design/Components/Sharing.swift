import ContentKit
import SwiftUI

/// What the app shares: the text with its source always attached, and any notice its licence
/// requires (docs/product.md §7; P3.5 supplies the notices).
struct ShareableText: Hashable, Sendable {
    let body: String
    let source: SourceDetails
    /// A notice the text's licence requires, shown after the source.
    var notice: String?

    /// The text exactly as it is shared: the body, then the source line, then any notice.
    nonisolated var formatted: String {
        let citation = source.citation
        let sourceLine = String(
            localized: "— \(String(localized: citation.book.title)), \(source.printingTitle), p. \(citation.page)",
            comment: "The source line attached to shared text"
        )
        return ([body, sourceLine] + [notice].compactMap { $0 }).joined(separator: "\n\n")
    }
}

/// A share button that always attaches the source. The share sheet shows exactly what goes.
struct AttributedShareLink: View {
    let shareable: ShareableText

    var body: some View {
        ShareLink(
            item: shareable.formatted,
            preview: SharePreview(Text(shareable.source.citation.book.title))
        ) {
            Label {
                Text("Share")
            } icon: {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .foregroundStyle(Color.rubric)
    }
}
