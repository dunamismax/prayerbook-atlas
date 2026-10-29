import XCTest

/// The Debug component gallery (BUILD.md P2.5) opens, scrolls to its end, and is kept as
/// screenshots in day and night for review.
final class ComponentGalleryUITests: XCTestCase {
    @MainActor
    func testGalleryInDayAndNight() {
        addTeardownBlock { @MainActor in XCUIDevice.shared.appearance = .light }
        let app = XCUIApplication()
        app.launchArguments = ["-resetNavigation", "-componentGallery"]
        for appearance in [XCUIDevice.Appearance.light, .dark] {
            XCUIDevice.shared.appearance = appearance
            app.launch()
            let gallery = app.scrollViews["component-gallery"]
            XCTAssertTrue(gallery.waitForExistence(timeout: 5))
            let mode = appearance == .dark ? "night" : "day"
            keepScreenshot(of: app, named: "gallery-top-\(mode)")
            gallery.swipeUp(velocity: .slow)
            keepScreenshot(of: app, named: "gallery-middle-\(mode)")
            gallery.swipeUp(velocity: .fast)
            gallery.swipeUp(velocity: .fast)
            XCTAssertTrue(app.buttons["Share"].waitForExistence(timeout: 5))
            keepScreenshot(of: app, named: "gallery-end-\(mode)")
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
