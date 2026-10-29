/// The prayer books the app carries, by stable identifier.
///
/// The raw values are stored in content files and user settings, so they never
/// change once released (pinned by `PrayerBookIDTests`). The launch books
/// follow D3's working default; books added by permission (D6) get new cases.
public enum PrayerBookID: String, CaseIterable, Codable, Sendable {
    /// The Church of England's Book of Common Prayer of 1662.
    case bcp1662
    /// The Episcopal Church's (American) Book of Common Prayer of 1928.
    case bcp1928us
    /// The Episcopal Church's Book of Common Prayer of 1979.
    case bcp1979us
}
