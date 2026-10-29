import SwiftUI
import UIKit

/// The primary action: an outlined, square button in the accent, its label in uppercase SF
/// semibold (`action`, docs/design.md §8). One per screen.
struct PrimaryActionStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .typeStyle(.action)
            .foregroundStyle(Color.rubric)
            .padding(.horizontal, Spacing.l + 2)
            .frame(minHeight: 44)
            .background(configuration.isPressed ? Color.wash : Color.clear)
            .overlay(Rectangle().strokeBorder(Color.rubric, lineWidth: Rule.hairline))
            .contentShape(Rectangle())
    }
}

extension ButtonStyle where Self == PrimaryActionStyle {
    static var primaryAction: PrimaryActionStyle { PrimaryActionStyle() }
}

/// The empty, loading, and error states, in words first: an optional symbol, a title, and a
/// plain message. Never a scolding, never urgent (docs/product.md §5).
struct StatusView: View {
    enum Kind {
        case empty(title: LocalizedStringResource, message: LocalizedStringResource)
        case loading(LocalizedStringResource)
        case error(message: LocalizedStringResource, retry: (() -> Void)?)
    }

    let kind: Kind
    var systemImage: String?

    var body: some View {
        VStack(spacing: Spacing.m) {
            switch kind {
            case .empty(let title, let message):
                symbol
                Text(title).typeStyle(.heading).foregroundStyle(Color.ink)
                Text(message).typeStyle(.source).foregroundStyle(Color.muted)
            case .loading(let label):
                ProgressView().tint(Color.muted)
                Text(label).typeStyle(.source).foregroundStyle(Color.muted)
            case .error(let message, let retry):
                symbol
                Text(message).typeStyle(.source).foregroundStyle(Color.ink)
                if let retry {
                    Button("Try again", action: retry).buttonStyle(.primaryAction)
                }
            }
        }
        .multilineTextAlignment(.center)
        .padding(Spacing.xl)
        .frame(maxWidth: Spacing.readingMeasure)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var symbol: some View {
        if let systemImage {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundStyle(Color.muted)
                .accessibilityHidden(true)
        }
    }
}

/// Haptics for the person's own actions only, never to draw attention (docs/product.md §4).
@MainActor
enum Haptics {
    /// A choice made: an alternative chosen, a day changed.
    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    /// Something the person asked for is done: an intention saved.
    static func done() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
