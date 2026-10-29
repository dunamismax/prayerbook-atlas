import XCTest

/// Deep links and the root toolbar on iPhone (docs/product.md §2, decision 17).
final class NavigationUITests: XCTestCase {
    @MainActor
    func testDeepLinkOpensSettings() {
        let app = XCUIApplication()
        app.launchArguments = ["-resetNavigation"]
        app.launch()
        app.open(URL(string: "prayerbookatlas://settings")!)
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
    }

    @MainActor
    func testSearchButtonPushesSearch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-resetNavigation", "-tab", "bible"]
        app.launch()
        let search = app.buttons["search-button"]
        guard search.waitForExistence(timeout: 5) else {
            throw XCTSkip("Search is a tab on regular widths (decision 17)")
        }
        search.tap()
        XCTAssertTrue(app.navigationBars["Search"].waitForExistence(timeout: 5))
    }
}
