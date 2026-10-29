# Releasing builds: TestFlight now, the App Store later

How a build of Prayerbook Atlas gets from this repository onto an iPhone. Until version 1.0
(Phase 21), every build goes to **TestFlight internal testing**: the owner installs the
TestFlight app once and then receives each new build automatically, with no cable and no
registered device. A TestFlight build runs for 90 days; a newer upload replaces it.

The app is published from the owner's individual Apple Developer account (D13's working
default): team `D9QMP3LP8H`, bundle ID `com.prayerbookatlas.app` (D1). Every step that signs
in to Apple, accepts an agreement, or uploads is the owner's, or waits for the owner's go-ahead
(AGENTS.md §4 and §9).

**State (2026-10-28):** prepared, not yet run. An unsigned Release archive for devices
(`CODE_SIGNING_ALLOWED=NO`) builds with zero warnings and carries the privacy manifest, the
icon, version 0.1.0, and `ITSAppUsesNonExemptEncryption = NO`. Nothing has been signed or
uploaded. The one-time setup below is still to do.

## One-time setup (the owner)

1. **Agreements.** Accept the current Program License Agreement at
   [developer.apple.com/account](https://developer.apple.com/account) and any agreement shown at
   [App Store Connect → Business](https://appstoreconnect.apple.com/agreements). Until the
   latest is accepted, Xcode cannot create certificates or profiles, and the archive fails
   with "PLA Update available".
2. **The Team ID (P0.6).** Uncomment `DEVELOPMENT_TEAM = D9QMP3LP8H` in
   `Config/Base.xcconfig` (or ask an agent to), and make sure the owner's Apple ID is in Xcode →
   Settings → Accounts. A Team ID is not secret; it is committed, as on Beautiful Corner.
3. **The bundle ID.** The first successful `make archive` registers `com.prayerbookatlas.app`
   through Xcode's automatic signing. (It can also be added by hand under Certificates,
   Identifiers & Profiles → Identifiers.)
4. **The app record (P0.7).** [App Store Connect → Apps](https://appstoreconnect.apple.com/apps)
   → **+ → New App**: platform iOS, name **Prayerbook Atlas**, primary language English (U.S.),
   bundle ID `com.prayerbookatlas.app`, SKU `com.prayerbookatlas.app`, full access. If Xcode's
   Organizer creates the record during a first distribution instead, it names it after the
   product ("PrayerbookAtlas"); correct the name under App Information.
5. **The internal testing group.** TestFlight tab → Internal Testing → **+**: a group (for
   example **Owner**) with automatic distribution on, and the owner's Apple ID as its tester.
6. **On the iPhone.** Install [TestFlight](https://apps.apple.com/app/testflight/id899247664),
   signed in with the same Apple ID, and accept the invitation.

## Every build

```sh
make check        # everything, including a Release simulator build
make testflight   # archive, sign, and upload
```

`make testflight` runs, in order:

1. `make content-release`: the content compiler in release mode, which fails on any source
   not `cleared` in `content/SOURCES.md` and on any original work not `review: approved`
   (once the compiler exists, P3.3). A TestFlight build ships only what a release may ship.
2. `make archive`: a signed Release archive for devices at `build/PrayerbookAtlas.xcarchive`.
   The build number is the UTC date and time (`20261028.2300`), so every upload is newer than
   the last; `BUILD_NUMBER=…` overrides it. The marketing version is `MARKETING_VERSION` in
   `Config/Base.xcconfig` (0.1.0 until 1.0).
3. `xcodebuild -exportArchive` with `Config/ExportOptions.plist`: Xcode signs the build for
   App Store Connect (automatic signing, `-allowProvisioningUpdates`) and uploads it.

Nothing about signing is committed except the Team ID; certificates live in the login
keychain and profiles in `~/Library/Developer/Xcode/UserData/Provisioning Profiles`. App Store
Connect processes each upload before it reaches testers. Record each upload's build number
and source commit in BUILD.md's Handoff notes.

If `xcodebuild -exportArchive` reports `Failed to Use Accounts` although the archive signed,
open the archive in Xcode → Window → Organizer and use Distribute App → **TestFlight Internal
Only** (Beautiful Corner met this once). Internal-only builds cannot go to external testers or
the App Store.

## What a build must carry

- **Export compliance.** The app uses no encryption beyond Apple's own (HTTPS through the
  system), so `ITSAppUsesNonExemptEncryption` is `NO` in `project.yml`.
- **The privacy manifest.** `App/Resources/PrivacyInfo.xcprivacy` declares no tracking and no
  collected data (decision 15). It declares no required-reason API, because the app calls
  none yet. App Store Connect rejects an upload that calls one undeclared, so add the entry
  when the app first uses `UserDefaults` (`CA92.1`), file timestamps, disk space, system boot
  time, or the active keyboards.
- **The app icon.** The placeholder is the generated Ribbon icon (P1.11), still `pending`
  release review; it is acceptable for internal TestFlight builds. The final icon is P21.8.

## When something fails

| Message | Cause and fix |
| --- | --- |
| `PLA Update available … agree to the latest Program License Agreement` | Setup step 1: the account holder accepts the agreement. |
| `Signing for "App" requires a development team` | Setup step 2: the Team ID line is still commented. |
| `No profiles for 'com.prayerbookatlas.app' were found` | The agreement is pending, or the Apple ID is missing from Xcode → Settings → Accounts. |
| `No suitable application records were found` | Setup step 4: the App Store Connect record does not exist yet. |
| `The bundle version must be higher than the previously uploaded version` | Pass a larger `BUILD_NUMBER`, or wait a minute for the timestamp to move on. |
| `ITMS-91053: Missing API declaration` | Add the API's category and reason to the privacy manifest. |
