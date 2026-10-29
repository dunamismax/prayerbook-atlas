import Testing

@testable import ContentKit

struct PrayerBookIDTests {
    @Test func rawValuesNeverChange() {
        #expect(PrayerBookID.allCases.map(\.rawValue) == ["bcp1662", "bcp1928us", "bcp1979us"])
    }
}
