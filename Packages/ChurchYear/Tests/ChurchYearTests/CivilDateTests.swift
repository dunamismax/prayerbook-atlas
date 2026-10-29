import Testing

@testable import ChurchYear

struct CivilDateTests {
    @Test(arguments: [(2024, true), (2026, false), (1900, false), (2000, true), (2100, false)])
    func leapYears(year: Int, isLeap: Bool) {
        #expect(CivilDate.isLeapYear(year) == isLeap)
    }

    @Test func rejectsImpossibleDates() {
        #expect(CivilDate(year: 2026, month: 2, day: 29) == nil)
        #expect(CivilDate(year: 2026, month: 4, day: 31) == nil)
        #expect(CivilDate(year: 2026, month: 13, day: 1) == nil)
        #expect(CivilDate(year: 2026, month: 1, day: 0) == nil)
        #expect(CivilDate(year: 2028, month: 2, day: 29) != nil)
    }

    @Test func ordersAndPrintsDates() throws {
        let earlier = try #require(CivilDate(year: 2026, month: 12, day: 31))
        let later = try #require(CivilDate(year: 2027, month: 1, day: 1))
        #expect(earlier < later)
        #expect(later.description == "2027-01-01")
    }
}
