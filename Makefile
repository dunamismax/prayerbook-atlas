# Prayerbook Atlas — run `make help` for the list of targets.
#
#   generate       Generate PrayerbookAtlas.xcodeproj from project.yml with XcodeGen
#   content        Check content/ and write App/Resources/Content.sqlite (pending sources allowed)
#   content-release  The same, failing on any source not cleared or original work awaiting review
#   build          Build the Debug app for the simulator, failing on any warning
#   build-release  Build Release for the simulator with release-checked content
#   test-packages  Run every package's tests with swift test (warnings are errors)
#   test-app       Run the app's unit and UI tests in the simulator, failing on any warning
#   test-linux     Run every package's tests on Linux in the swift:6.4 container
#   run            Build, boot the simulator, install, and launch the app
#   screenshot     Relaunch the app and save a screenshot to screenshots/ (APPEARANCE, TEXT_SIZE)
#   archive        Archive a signed Release build for devices, with release-checked content (BUILD_NUMBER)
#   testflight     Archive, then upload the build to App Store Connect for TestFlight (docs/release.md)
#   icon           Copy the placeholder app icon from design/generated/ into the asset catalog
#   guards         Check package imports are Linux-safe and the app icon matches its sources
#   check          Lint, guards, package tests, content, app tests, and a Release build
#   format         Format every Swift file in place with swift format
#   lint           Check formatting and style with swift format (fails on any finding)
#   clean          Remove build output and the generated project
#
# SIM_DEVICE picks the simulator by name or UDID (default: the newest iPhone).
# APPEARANCE (light or dark) and TEXT_SIZE (a simctl content size, for example
# accessibility-extra-extra-extra-large) apply to `run` and `screenshot`, and
# LAUNCH_ARGS passes launch arguments to the app. BUILD_NUMBER sets the archive's build
# number (default: the UTC date and time, 20261028.2230, so every upload is newer than the last).

PROJECT       := PrayerbookAtlas.xcodeproj
SCHEME        := PrayerbookAtlas
BUNDLE_ID     := com.prayerbookatlas.app
DERIVED       := build/DerivedData
APP_PATH      := $(DERIVED)/Build/Products/Debug-iphonesimulator/PrayerbookAtlas.app
PACKAGES      := $(sort $(dir $(wildcard Packages/*/Package.swift)))
SWIFT_SOURCES := $(wildcard App AppTests AppUITests Packages Tools scripts)
LINUX_IMAGE   := swift:6.4
CONTENT_TOOL  := Tools/ContentCompiler
ARCHIVE       := build/PrayerbookAtlas.xcarchive
BUILD_NUMBER  := $(or $(BUILD_NUMBER),$(shell date -u +%Y%m%d.%H%M))
CONTENT_ARGS  := --content content --output App/Resources/Content.sqlite --verify

# Resolved only by the targets that use a simulator.
SIM_UDID = $(shell scripts/sim-destination.sh)
XCODEBUILD = xcodebuild -project $(PROJECT) -scheme $(SCHEME) \
	-destination "platform=iOS Simulator,id=$(SIM_UDID)" -derivedDataPath $(DERIVED) -quiet

# The content compiler arrives in P3.3; until then the content targets have nothing to do.
define compile_content
	@if [ -f $(CONTENT_TOOL)/Package.swift ]; then \
		swift build --package-path $(CONTENT_TOOL) -c release -Xswiftc -warnings-as-errors --quiet && \
		"$$(swift build --package-path $(CONTENT_TOOL) -c release --show-bin-path)/ContentCompiler" $(CONTENT_ARGS) $(1); \
	else \
		echo "content: no $(CONTENT_TOOL) yet (BUILD.md P3.3); nothing to compile"; \
	fi
endef

.PHONY: help generate content content-release build build-release test-packages test-app test-linux run screenshot \
	archive testflight icon guards check format lint clean

help:
	@sed -n 's/^#   //p' $(MAKEFILE_LIST)

generate:
	xcodegen generate --quiet

content:
	$(call compile_content,--allow-pending)

content-release:
	$(call compile_content,)

build: generate content
	rm -rf build/Build.xcresult
	$(XCODEBUILD) -resultBundlePath build/Build.xcresult build
	scripts/check-warnings.sh build/Build.xcresult

build-release: generate content-release
	rm -rf build/ReleaseBuild.xcresult
	$(XCODEBUILD) -configuration Release -resultBundlePath build/ReleaseBuild.xcresult build
	scripts/check-warnings.sh build/ReleaseBuild.xcresult

test-packages:
	@set -e; for p in $(PACKAGES); do \
		echo "swift test $$p"; \
		swift test --package-path $$p -Xswiftc -warnings-as-errors; \
	done

test-app: generate content
	rm -rf build/Test.xcresult
	$(XCODEBUILD) -resultBundlePath build/Test.xcresult \
		-test-timeouts-enabled YES -maximum-test-execution-time-allowance 300 \
		-collect-test-diagnostics never test
	scripts/check-warnings.sh build/Test.xcresult

test-linux:
	docker run --rm -v "$(CURDIR)":/src:ro -w /src $(LINUX_IMAGE) sh -c '\
		set -e; for p in $(PACKAGES); do \
			echo "swift test $$p (Linux)"; \
			swift test --package-path "$$p" --scratch-path "/tmp/build/$$p" -Xswiftc -warnings-as-errors; \
		done'

run: build
	@udid=$(SIM_UDID); \
	xcrun simctl boot $$udid 2>/dev/null || true; \
	xcrun simctl bootstatus $$udid -b > /dev/null; \
	open -a Simulator --args -CurrentDeviceUDID $$udid 2> /dev/null \
		|| echo "run: no Simulator.app on this Mac; the app runs in the booted simulator $$udid"; \
	$(if $(APPEARANCE),xcrun simctl ui $$udid appearance $(APPEARANCE);) \
	$(if $(TEXT_SIZE),xcrun simctl ui $$udid content_size $(TEXT_SIZE);) \
	xcrun simctl install $$udid $(APP_PATH); \
	xcrun simctl launch --terminate-running-process $$udid $(BUNDLE_ID) $(LAUNCH_ARGS)

screenshot:
	@mkdir -p screenshots; \
	udid=$(SIM_UDID); \
	$(if $(APPEARANCE),xcrun simctl ui $$udid appearance $(APPEARANCE);) \
	$(if $(TEXT_SIZE),xcrun simctl ui $$udid content_size $(TEXT_SIZE);) \
	xcrun simctl launch --terminate-running-process $$udid $(BUNDLE_ID) $(LAUNCH_ARGS) > /dev/null; \
	sleep 4; \
	file=screenshots/$$(date +%Y%m%d-%H%M%S)-$(or $(APPEARANCE),current)$(if $(TEXT_SIZE),-$(TEXT_SIZE)).png; \
	xcrun simctl io $$udid screenshot "$$file" 2> /dev/null; \
	echo "$$file"

# Signing is automatic with the owner's team (Config/Base.xcconfig, P0.6); -allowProvisioningUpdates
# lets Xcode create the certificate and profiles through the Apple ID signed in to Xcode.
archive: generate content-release
	rm -rf $(ARCHIVE)
	xcodebuild -project $(PROJECT) -scheme $(SCHEME) -configuration Release \
		-destination generic/platform=iOS -archivePath $(ARCHIVE) -derivedDataPath build/ArchiveData \
		-allowProvisioningUpdates -quiet CURRENT_PROJECT_VERSION=$(BUILD_NUMBER) archive
	@echo "archive: build $(BUILD_NUMBER) of $$(git rev-parse --short HEAD) at $(ARCHIVE)"

testflight: archive
	rm -rf build/Export
	xcodebuild -exportArchive -archivePath $(ARCHIVE) -exportOptionsPlist Config/ExportOptions.plist \
		-exportPath build/Export -allowProvisioningUpdates
	@echo "testflight: uploaded build $(BUILD_NUMBER); it appears in App Store Connect's TestFlight tab once processed"

icon:
	scripts/app-icon.sh

guards:
	scripts/check-package-imports.sh
	scripts/app-icon.sh --check

check: lint guards test-packages content test-app build-release

format:
	swift format format --in-place --recursive --parallel $(SWIFT_SOURCES)

lint:
	swift format lint --strict --recursive --parallel $(SWIFT_SOURCES)

clean:
	rm -rf build $(PROJECT) $(addsuffix .build,$(PACKAGES)) $(CONTENT_TOOL)/.build App/Resources/Content.sqlite
