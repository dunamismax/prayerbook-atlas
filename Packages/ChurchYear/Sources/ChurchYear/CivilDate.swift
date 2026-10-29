/// A day in the Gregorian calendar, with no time and no time zone.
///
/// Church-calendar logic works in civil dates only; `Date` appears only at the
/// interface edge (docs/decisions.md entry 8). P4.1 adds weekdays, day
/// arithmetic, and Julian Day Numbers.
public struct CivilDate: Hashable, Comparable, Codable, Sendable, CustomStringConvertible {
    public let year: Int
    public let month: Int
    public let day: Int

    /// Returns nil unless the year, month, and day name a real Gregorian date.
    public init?(year: Int, month: Int, day: Int) {
        guard (1...12).contains(month), (1...Self.daysInMonth(month, year: year)).contains(day) else {
            return nil
        }
        self.year = year
        self.month = month
        self.day = day
    }

    public static func isLeapYear(_ year: Int) -> Bool {
        (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }

    public static func daysInMonth(_ month: Int, year: Int) -> Int {
        switch month {
        case 2: isLeapYear(year) ? 29 : 28
        case 4, 6, 9, 11: 30
        default: 31
        }
    }

    public static func < (lhs: CivilDate, rhs: CivilDate) -> Bool {
        (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }

    /// The ISO 8601 form, for example `2027-03-28`.
    public var description: String {
        let y = String(year)
        let m = month < 10 ? "0\(month)" : String(month)
        let d = day < 10 ? "0\(day)" : String(day)
        return "\(y)-\(m)-\(d)"
    }
}
