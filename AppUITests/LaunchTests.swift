import XCTest

final class LaunchTests: XCTestCase {
    @MainActor
    func testLaunches() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertEqual(app.state, .runningForeground)
    }
}
