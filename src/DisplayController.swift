import Foundation
import CoreGraphics
import IOKit
import IOKit.pwr_mgt

// MARK: - Private DisplayServices & Login Framework Bindings
@_silgen_name("DisplayServicesGetBrightness")
func DisplayServicesGetBrightness(_ display: CGDirectDisplayID, _ brightness: UnsafeMutablePointer<Float>) -> Int32

@_silgen_name("DisplayServicesSetBrightness")
func DisplayServicesSetBrightness(_ display: CGDirectDisplayID, _ brightness: Float) -> Int32

@_silgen_name("DisplayServicesCanChangeBrightness")
func DisplayServicesCanChangeBrightness(_ display: CGDirectDisplayID) -> Bool

@_silgen_name("SACLockScreenImmediate")
func SACLockScreenImmediate() -> Int32

/// Manages macOS hardware display backlight and session locking for Apple Silicon.
public final class DisplayController {
    public static let shared = DisplayController()
    
    private let lock = NSLock()
    private var savedBrightnessCache: [CGDirectDisplayID: Float] = [:]
    public private(set) var isBacklightSuppressed: Bool = false
    
    public init() {}
    
    private var cachedBuiltinDisplayID: CGDirectDisplayID?
    
    /// Finds the built-in display ID (Liquid Retina / Retina panel on MacBooks) using online list.
    public func getBuiltinDisplayID() -> CGDirectDisplayID? {
        if let cached = cachedBuiltinDisplayID {
            return cached
        }
        var count: UInt32 = 0
        CGGetOnlineDisplayList(0, nil, &count)
        if count > 0 {
            var displays = [CGDirectDisplayID](repeating: 0, count: Int(count))
            CGGetOnlineDisplayList(count, &displays, &count)
            if let builtin = displays.first(where: { CGDisplayIsBuiltin($0) != 0 }) {
                cachedBuiltinDisplayID = builtin
                return builtin
            }
        }
        let main = CGMainDisplayID()
        cachedBuiltinDisplayID = main
        return main
    }
    
    /// Reads the current hardware brightness (0.0 ... 1.0).
    public func readBrightness(for displayID: CGDirectDisplayID? = nil) -> Float? {
        guard let id = displayID ?? getBuiltinDisplayID() else { return nil }
        var value: Float = 0.0
        let status = DisplayServicesGetBrightness(id, &value)
        return status == 0 ? value : nil
    }
    
    /// Puts all displays to sleep cleanly using macOS pmset.
    public func putDisplaysToSleep() {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        task.arguments = ["displaysleepnow"]
        try? task.run()
    }
    
    /// Wakes displays by signaling local user activity to powerd.
    public func wakeDisplays() {
        var assertionID: IOPMAssertionID = 0
        _ = IOPMAssertionDeclareUserActivity(
            "Dopamine Display Wake" as CFString,
            kIOPMUserActiveLocal,
            &assertionID
        )
    }
    
    /// Turns off the built-in display backlight (0.0 nits, hardware-off) for closed-lid mode.
    public func suppressBuiltinBacklight() {
        lock.lock()
        defer { lock.unlock() }
        
        guard !isBacklightSuppressed else { return }
        guard let displayID = getBuiltinDisplayID() else { return }
        
        // 1. Save user's current brightness safely (never save 0)
        if let current = readBrightness(for: displayID), current > 0.05 {
            savedBrightnessCache[displayID] = current
        } else if savedBrightnessCache[displayID] == nil || (savedBrightnessCache[displayID] ?? 0) < 0.05 {
            savedBrightnessCache[displayID] = 0.75
        }
        
        // 2. Set brightness to 0.0 and cleanly sleep displays (cuts panel power, stops ALS/CoreBrightness fight)
        _ = DisplayServicesSetBrightness(displayID, 0.0)
        putDisplaysToSleep()
        isBacklightSuppressed = true
        
        NSLog("[DisplayController] Built-in display suppressed to 0.0 and put to sleep (saved: %.2f)", savedBrightnessCache[displayID] ?? 0.75)
    }
    
    /// Restores the built-in display backlight to its saved level.
    public func restoreBuiltinBacklight() {
        lock.lock()
        defer { lock.unlock() }
        
        // HARD SAFETY CHECK: Never restore backlight if the lid is still physically closed!
        if ClamshellMonitor.readDirectHardwareLidState() {
            NSLog("[DisplayController] Refusing to restore backlight: Lid is still physically closed!")
            return
        }
        
        guard isBacklightSuppressed else { return }
        guard let displayID = getBuiltinDisplayID() else { return }
        
        var targetBrightness = savedBrightnessCache[displayID] ?? 0.75
        if targetBrightness < 0.15 {
            targetBrightness = 0.75
        }
        
        wakeDisplays()
        _ = DisplayServicesSetBrightness(displayID, targetBrightness)
        isBacklightSuppressed = false
        NSLog("[DisplayController] Built-in display backlight restored to %.2f", targetBrightness)
    }
    
    /// Fail-safe emergency restoration on crash or app termination.
    public func emergencyRestore() {
        lock.lock()
        defer { lock.unlock() }
        
        if isBacklightSuppressed, let displayID = getBuiltinDisplayID() {
            var target = savedBrightnessCache[displayID] ?? 0.75
            if target < 0.15 {
                target = 0.75
            }
            wakeDisplays()
            _ = DisplayServicesSetBrightness(displayID, target)
            isBacklightSuppressed = false
        }
    }
    
    /// Immediately locks the macOS user session.
    public func lockSession() {
        _ = SACLockScreenImmediate()
        NSLog("[DisplayController] macOS session locked")
    }
}
