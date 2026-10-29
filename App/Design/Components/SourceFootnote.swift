import ContentKit
import SwiftUI

extension PrayerBookID {
    /// The book's title as the app names it in sources and lists.
    var title: LocalizedStringResource {
        switch self {
        case .bcp1662: "The Book of Common Prayer (1662)"
        case .bcp1928us: "The Book of Common Prayer (1928)"
        case .bcp1979us: "The Book of Common Prayer (1979)"
        }
    }

    /// The short form used in source marks and compare columns.
    var shortTitle: LocalizedStringResource {
        switch self {
        case .bcp1662: "1662"
        case .bcp1928us: "1928"
        case .bcp1979us: "1979"
        }
    }
}

/// A source as shown to the person: the citation, and the printing's title from the content
/// database (P3).
struct SourceDetails: Hashable, Sendable {
    let citation: SourceCitation
    let printingTitle: String
}

/// The source mark after a text ("1662, p. 45"), in italic accent, which opens the source sheet
/// with the book, printing, and page (docs/design.md §6; Grace & Footnotes' sources one tap
/// away).
struct SourceFootnote: View {
    let source: SourceDetails
    @State private var isShowingSheet = false

    var body: some View {
        Button {
            isShowingSheet = true
        } label: {
            Text(
                "\(source.citation.book.shortTitle), p. \(source.citation.page)",
                comment: "A source mark: the book's short title and the printed page"
            )
            .typeStyle(.sourceMark)
            .foregroundStyle(Color.rubric)
            .frame(minHeight: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            Text(
                "Source: \(source.citation.book.title), page \(source.citation.page)",
                comment: "VoiceOver: a source mark"
            )
        )
        .accessibilityHint(Text("Shows the book, printing, and page"))
        .sheet(isPresented: $isShowingSheet) {
            SourceSheet(source: source)
                .presentationDetents([.medium, .large])
        }
    }
}

/// The source sheet: where a text comes from, plainly.
struct SourceSheet: View {
    let source: SourceDetails
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    Eyebrow("Source")
                    Text(source.citation.book.title)
                        .typeStyle(.title)
                        .foregroundStyle(Color.ink)
                    DoubleRule()
                    LabeledLine(label: "Printing", value: source.printingTitle)
                    LabeledLine(label: "Printed page", value: source.citation.page)
                    Text(
                        "Transcribed from the page images of this printing and proofread against them.",
                        comment: "Source sheet: how texts are prepared (AGENTS.md §6)"
                    )
                    .typeStyle(.source)
                    .foregroundStyle(Color.muted)
                }
                .padding(Spacing.margin)
                .frame(maxWidth: Spacing.readingMeasure, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .background(Color.paper)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

/// A label and its value, stacked: the label as a small-capital eyebrow.
private struct LabeledLine: View {
    let label: LocalizedStringResource
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Eyebrow(label)
            Text(verbatim: value).typeStyle(.reading).foregroundStyle(Color.ink)
        }
        .accessibilityElement(children: .combine)
    }
}
