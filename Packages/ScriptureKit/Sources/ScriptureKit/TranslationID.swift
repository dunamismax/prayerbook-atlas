/// The Bible translations the app carries, by stable identifier.
///
/// Every passage names its translation (D5). The raw values are stored in
/// content files and user settings, so they never change once released
/// (pinned by `TranslationIDTests`). Licensed translations get new cases only
/// when content/SOURCES.md records the license. The prayer books' own Psalters
/// are not translations here: they belong to each book's text.
public enum TranslationID: String, CaseIterable, Codable, Sendable {
    /// The King James Version, with the Apocrypha.
    case kjva
    /// The World English Bible, with the deuterocanonical books.
    case web
}
