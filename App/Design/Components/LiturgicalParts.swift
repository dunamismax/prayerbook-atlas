import SwiftUI

/// How rubrics are shown: italic in the accent, or italic in ink (a reading setting, P2.10).
enum RubricPresentation: String, CaseIterable, Sendable {
    case colour, italic
}

extension EnvironmentValues {
    @Entry var rubricPresentation: RubricPresentation = .colour
}

/// A rubric: an instruction, never words to be said (`rubric`, docs/design.md §6). VoiceOver
/// announces it as an instruction.
struct RubricText: View {
    let text: String
    @Environment(\.rubricPresentation) private var presentation

    var body: some View {
        Text(verbatim: text)
            .typeStyle(.rubric)
            .foregroundStyle(presentation == .colour ? Color.rubric : Color.ink)
            .accessibilityLabel(Text("Instruction: \(text)", comment: "VoiceOver: a rubric, read as an instruction"))
    }
}

/// A paragraph of reading text that opens with an initial in the accent (docs/design.md §6).
///
/// The initial is an enlarged capital on the first line. The two-line drop initial needs
/// text that wraps around it, which comes with the TextKit renderer in P2.9; at accessibility
/// sizes the design keeps this inline form anyway.
struct InitialParagraph: View {
    let text: String
    @ScaledMetric(relativeTo: .body) private var size: CGFloat = TypeStyle.reading.size

    var body: some View {
        var initial = AttributedString(String(text.prefix(1)))
        initial.font = TypeStyle.reading.font(size: size * 1.6)
        initial.foregroundColor = Color.rubric
        return Text(initial + AttributedString(String(text.dropFirst())))
            .typeStyle(.reading)
            .foregroundStyle(Color.ink)
            .accessibilityLabel(Text(verbatim: text))
    }
}

/// A line with its role, as in versicles and responses: the label exactly as the book prints
/// it ("℣", "Minister", "Answer") and the words that follow.
struct RoleLine: Hashable, Sendable {
    let role: String
    let text: String
}

/// Versicles and responses, each line led by its role label. Side by side at ordinary sizes,
/// stacked at accessibility sizes so neither column is squeezed.
struct VersicleResponse: View {
    let lines: [RoleLine]
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        if typeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: Spacing.m) {
                ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        RoleLabel(text: line.role)
                        reading(line.text)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        } else {
            Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: Spacing.m, verticalSpacing: Spacing.s) {
                ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                    GridRow {
                        RoleLabel(text: line.role)
                        reading(line.text)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    private func reading(_ text: String) -> some View {
        Text(verbatim: text).typeStyle(.reading).foregroundStyle(Color.ink)
            .fixedSize(horizontal: false, vertical: true)
    }
}

/// The Amen as the book prints it: its words and emphasis come from the text, not the app.
struct AmenLine: View {
    enum Emphasis: Sendable { case plain, italic }

    let text: String
    var emphasis: Emphasis = .plain

    var body: some View {
        Text(verbatim: text)
            .typeStyle(emphasis == .italic ? .rubric : .reading)
            .foregroundStyle(Color.ink)
    }
}

/// A mark that the preceding words are said more than once, used only where the book itself
/// directs the repetition. The mark is the app's own, so it is quiet and labelled.
struct RepetitionMark: View {
    let times: Int

    var body: some View {
        Text("×\(times)", comment: "A mark that words are repeated, with the count")
            .typeStyle(.sourceMark)
            .foregroundStyle(Color.rubric)
            .accessibilityLabel(Text("Said \(times) times", comment: "VoiceOver: words said more than once"))
    }
}

/// A name from the person's own intercession list, set into a prayer where the book provides
/// for one (P13.3). Square, on `wash`, so it reads as the person's insertion, not the book's.
struct NameChip: View {
    let name: String

    var body: some View {
        Text(verbatim: name)
            .typeStyle(.reading)
            .foregroundStyle(Color.ink)
            .padding(.horizontal, Spacing.s)
            .padding(.vertical, 2)
            .background(Color.wash)
            .overlay(Rectangle().strokeBorder(Color.line, lineWidth: Rule.hairline))
            .accessibilityLabel(Text("Name from your list: \(name)", comment: "VoiceOver: an intercession name"))
    }
}

/// A note beside the text on wide layouts, and below it on narrow ones.
struct MarginNote<Content: View>: View {
    let note: String
    @ViewBuilder var content: Content
    @Environment(\.horizontalSizeClass) private var sizeClass
    @ScaledMetric(relativeTo: .subheadline) private var noteWidth: CGFloat = 180

    var body: some View {
        if sizeClass == .regular {
            HStack(alignment: .firstTextBaseline, spacing: Spacing.xl) {
                content.frame(maxWidth: Spacing.readingMeasure, alignment: .leading)
                noteText.frame(width: noteWidth, alignment: .leading)
            }
        } else {
            VStack(alignment: .leading, spacing: Spacing.s) {
                content
                noteText
            }
        }
    }

    private var noteText: some View {
        Text(verbatim: note).typeStyle(.source).foregroundStyle(Color.muted)
    }
}
