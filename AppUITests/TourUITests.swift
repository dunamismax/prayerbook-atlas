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
            for tab in ["today", "pray", "bible", "kalendar", "atlas"] {
                let button = app.buttons["tab-\(tab)"]
                XCTAssertTrue(button.waitForExistence(timeout: 5), "no \(tab) tab")
                button.tap()
                keepScreenshot(of: app, named: "\(tab)-\(mode)")
            }
            app.buttons["tab-today"].tap()
            app.buttons["settings-button"].tap()
            XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5))
            keepScreenshot(of: app, named: "settings-\(mode)")
        }
    }

    @MainActor
    private func keepScreenshot(of app: XCUIApplication, named name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
