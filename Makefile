# Prayerbook Atlas — run `make help` for the list of targets.
#
#   format         Format every Swift file in place with swift format
#   lint           Check formatting and style with swift format (fails on any finding)

SWIFT_SOURCES := $(wildcard App AppTests AppUITests Packages Tools scripts)

.PHONY: help format lint

help:
	@sed -n 's/^#   //p' $(MAKEFILE_LIST)

format:
	swift format format --in-place --recursive --parallel $(SWIFT_SOURCES)

lint:
	swift format lint --strict --recursive --parallel $(SWIFT_SOURCES)
