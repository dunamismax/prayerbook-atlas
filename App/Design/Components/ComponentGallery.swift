#if DEBUG
    import ContentKit
    import SwiftUI

    /// Every shared component on one screen, for checking in the simulator in day, night, and
    /// large text (`-componentGallery`, Debug builds only). Every word is a bracketed placeholder
    /// or the app's own: no prayer-book text is ever typed from memory (AGENTS.md §6).
    struct ComponentGallery: View {
        static let launchArgument = "-componentGallery"

        private let source = SourceDetails(
            citation: SourceCitation(book: .bcp1662, printing: "placeholder", page: "—"),
            printingTitle: "[Printing]"
        )

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    Eyebrow(placeholder("[Eyebrow]"))
                    Text(verbatim: "[Title]").typeStyle(.title).foregroundStyle(Color.ink)
                    DoubleRule()

                    RubricText(text: "[A rubric: an instruction, not words to be said.]")
                    InitialParagraph(text: "[Reading text that opens with an initial, wrapping onto more lines.]")
                    VersicleResponse(lines: [
                        RoleLine(role: "[Role]", text: [.text("[The first line.]")]),
                        RoleLine(role: "[Role]", text: [.text("[The answer.]")]),
                    ])
                    HStack(alignment: .firstTextBaseline, spacing: Spacing.s) {
                        AmenLine(text: "[Amen]")
                        RepetitionMark(times: 3)
                    }
                    HStack(spacing: Spacing.s) {
                        Text(verbatim: "[For]").typeStyle(.reading).foregroundStyle(Color.ink)
                        NameChip(name: "[A name]")
                    }
                    HStack {
                        SourceFootnote(source: source)
                        Spacer()
                        PageNumberMark(page: "—")
                    }

                    PlateCard(label: placeholder("[Card label]"), labelColor: .rubric) {
                        Text(verbatim: "[Card title]").typeStyle(.title).foregroundStyle(Color.ink)
                        Text(verbatim: "[Book · office]").typeStyle(.source).foregroundStyle(Color.muted)
                        Button(placeholder("[Begin]")) {}.buttonStyle(.primaryAction)
                    }
                    AtlasPlate(label: placeholder("[Atlas plate]")) {
                        Text(verbatim: "[Compared text]").typeStyle(.reading).foregroundStyle(Color.ink)
                        Hairline()
                        Text(verbatim: "[Compared text]").typeStyle(.reading).foregroundStyle(Color.ink)
                    }
                    VStack(alignment: .leading, spacing: Spacing.s) {
                        ForEach(RibbonColour.allCases, id: \.self) { RibbonMarker(ribbon: $0) }
                    }
                    MarginNote(note: "[A margin note]") {
                        Text(verbatim: "[Reading text beside a note]").typeStyle(.reading).foregroundStyle(Color.ink)
                    }
                    StatusView(
                        kind: .empty(title: placeholder("[Empty title]"), message: placeholder("[Empty message]")),
                        systemImage: "tray"
                    )
                    StatusView(kind: .loading(placeholder("[Loading]")))
                    StatusView(kind: .error(message: placeholder("[Error message]"), retry: {}))
                    AttributedShareLink(shareable: ShareableText(body: "[Text]", source: source))
                }
                .padding(Spacing.margin)
                .frame(maxWidth: Spacing.readingMeasure, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .background(Color.paper)
            .accessibilityIdentifier("component-gallery")
        }

        /// Placeholder words that stay out of the String Catalog.
        private func placeholder(_ text: String) -> LocalizedStringResource {
            LocalizedStringResource(String.LocalizationValue(text))
        }
    }
#endif
