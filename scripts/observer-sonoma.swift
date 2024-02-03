#!/usr/bin/env DYLD_FRAMEWORK_PATH=/System/Library/Frameworks /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift
/*
*
* observer.swift
*
* Swift script to observe macOS color scheme changes
*
*/
import Cocoa

extension Notification.Name {
    static let AppleInterfaceThemeChangedNotification = Notification.Name("AppleInterfaceThemeChangedNotification")
}

func styleChange() {
    let currentScheme = UserDefaults
        .standard
        .string(forKey: "AppleInterfaceStyle") ?? "Light"
    let mode = currentScheme == "Dark" ? "0" : "1"

    print(mode)
    fflush(stdout)
}

/* Initial check */
styleChange()

/* Observe interface changes */
DistributedNotificationCenter
    .default
    .addObserver(
        forName: .AppleInterfaceThemeChangedNotification,
        object: nil,
        queue: nil) { (notification) in styleChange() }

/* Check interface on wake */
NSWorkspace
    .shared
    .notificationCenter
    .addObserver(
        forName: NSWorkspace.didWakeNotification,
        object: nil,
        queue: nil) { (notification) in styleChange() }

NSApplication.shared.run()
