# FabVex Mileage — iPhone V1

Native SwiftUI iPhone mileage/work-session tracker designed for local-first use.

## What is included
- Start Work / End Work
- Work sources: Amazon Flex, DoorDash, 3D Printing, Other
- SwiftData local persistence
- Background Core Location tracking
- Raw + filtered + reconstructed mileage and confidence
- GPS gap/noise filtering
- Interrupted-session persistence/recovery foundation
- Home Base/settings model
- Saved work-location model
- Scheduled block model
- Earnings: expected/actual + adjustments
- Vehicle + MPG history model
- Gas price history model
- Expense model
- Mileage correction
- Activity history
- CSV and PDF report export
- iPhone widget with Start/End deep links
- Offline-first architecture
- Unit-test foundation

## Build/install path from Windows 10
Apple's iOS toolchain is Xcode, which runs on macOS. The practical Windows workflow is:

1. Keep this project on Windows/GitHub.
2. Use a hosted macOS runner (GitHub Actions or another Mac build service) to run Xcode.
3. Configure your Apple Developer team/signing on the Mac runner.
4. Produce an App Store/TestFlight build.
5. Install TestFlight on your iPhone and install the build.

Apple documents that Xcode is the tool used to build/test/distribute iOS apps and that physical-device testing is performed through Xcode on a Mac. See Apple's iOS and Xcode documentation.

## One-time Apple setup
- An Apple Account is enough for some development/testing workflows, but distribution/TestFlight requires Apple Developer Program membership.
- Create/confirm a unique bundle ID: `com.fabvex.mileage`.
- Register the Widget extension bundle ID: `com.fabvex.mileage.widget`.
- Enable the App Group `group.com.fabvex.mileage` for both targets.
- Enable Background Modes > Location updates for the app target.
- Confirm Location permissions/usage descriptions in the app target.

## GitHub Actions signing
The workflow in `.github/workflows/ios-testflight.yml` is a template. Before using it, add the required Apple signing secrets/certificates to the repository or use your chosen secure signing service. Do not commit certificates or API private keys.

## Important limitation
This repository can be prepared and packaged on Windows, but Apple signing, Xcode compilation, and final physical-device verification still require macOS/Xcode. The source intentionally uses native Swift/SwiftUI/Core Location because those are the correct iPhone-native APIs for reliable background GPS.
