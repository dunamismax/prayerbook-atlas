import Foundation
import Testing

@testable import PrayerbookAtlas

struct AppTests {
    @Test func appModuleLoads() {
        #expect(Bundle.main.bundleIdentifier == "com.prayerbookatlas.app")
    }
}
