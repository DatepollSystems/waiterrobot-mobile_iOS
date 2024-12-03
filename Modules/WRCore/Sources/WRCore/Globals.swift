import Foundation
import shared
import SwiftUI
import UIKit

public var koin: IosKoinComponent { IosKoinComponent.shared }

public var localize: shared.L.Companion { shared.L.Companion.shared }

public enum WRCore {
    /// Setup of frameworks and all the other related stuff which is needed everywhere in the app
    public static func setup() {
        print("started app setup")
        var appVersion = readFromInfoPlist(withKey: "CFBundleShortVersionString")
        let versionSuffix = readFromInfoPlist(withKey: "VERSION_SUFFIX")
        if !versionSuffix.isEmpty {
            appVersion += "-\(versionSuffix)"
        }

        CommonApp.shared.doInit(
            appVersion: appVersion,
            appBuild: Int32(readFromInfoPlist(withKey: "CFBundleVersion"))!,
            phoneModel: UIDevice.current.model,
            os: OS.Ios(version: UIDevice.current.systemVersion),
            allowedHostsCsv: readFromInfoPlist(withKey: "ALLOWED_HOSTS"),
            stripeProvider: nil,
            koinPlatformDeclaration: nil
        )

        let logger = koin.logger(tag: "AppDelegate")

        KMMResourcesLocalizationKt.localizationBundle = Bundle(for: shared.L.self)
        logger.d { "initialized localization bundle" }
        print("finished app setup")
    }

    private static func readFromInfoPlist(withKey key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[key] as? String else {
            print("ERROR")
            fatalError("Could not find key '\(key)' in info.plist file.")
        }

        return value
    }
}

public extension EnvironmentValues {
    var isPreview: Bool {
        #if DEBUG
            return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
            return false
        #endif
    }
}
