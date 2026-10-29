import XCTest

/// Launches, visits every tab, opens Settings, and switches appearance, keeping a screenshot of
/// each step as a test attachment (BUILD.md P2.14). The device appearance is switched until
/// Settings has its own appearance control (P2.12).
final class TourUITests: XCTestCase {
    @MainActor
    func testTour() {
        // Leave the simulator in day mode for the tests that follow.
        addTeardownBlock { @MainActor in XCUIDevice.shared.appearance = .light }
        let app = XCUIApplication()
        app.launchArguments = ["-resetNavigation"]

        for appearance in [XCUIDevice.Appearance.light, .dark] {
            // A fresh launch per appearance: on iOS 27 the navigation bar's back button is not
            // reliably exposed to UI tests as a button.
            XCUIDevice.shared.appearance = appearance
            app.launch()
            let mode = appearance == .dark ? "night" : "day"
            for (tab, title) in Self.tabs {
                let button = tabButton(app, tab, title)
                XCTAssertTrue(button.waitForExistence(timeout: 5), "no \(tab) tab")
                button.tap()
                keepScreenshot(of: app, named: "\(tab)-\(mode)")
            }
            tabButton(app, "today", "Today").tap()
            app.buttons["settings-button"].tap()
            XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
            keepScreenshot(of: app, named: "settings-\(mode)")
        }
    }

    private static let tabs = [
        ("today", "Today"), ("pray", "Pray"), ("bible", "Bible"), ("kalendar", "Kalendar"), ("atlas", "Atlas"),
    ]

    /// A tab's button by its identifier, or by its title: the iOS 27 tab bar sometimes drops the
    /// tabs' identifiers (seen 2026-10-29 on iPhone 17 Pro, one run in two).
    @MainActor
    private func tabButton(_ app: XCUIApplication, _ tab: String, _ title: String) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "identifier == %@ OR label == %@", "tab-\(tab)", title)).firstMatch
    }

    @MainActor
    private func keepScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
