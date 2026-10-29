import Testing

@testable import ScriptureKit

struct TranslationIDTests {
    @Test func rawValuesNeverChange() {
        #expect(TranslationID.allCases.map(\.rawValue) == ["kjva", "web"])
    }
}
