import Foundation
import CoreGraphics

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
    
    /// Finds the built-in display ID (Liquid Retina / Retina panel on MacBooks).
    public func getBuiltinDisplayID() -> CGDirectDisplayID? {
        var count: UInt32 = 0
        CGGetActiveDisplayList(0, nil, &count)
        guard count > 0 else { return nil }
        
        var displays = [CGDirectDisplayID](repeating: 0, count: Int(count))
        CGGetActiveDisplayList(count, &displays, &count)
        
        return displays.first { CGDisplayIsBuiltin($0) != 0 } ?? CGMainDisplayID()
    }
    
    /// Reads the current hardware brightness (0.0 ... 1.0).
    public func readBrightness(for displayID: CGDirectDisplayID? = nil) -> Float? {
        guard let id = displayID ?? getBuiltinDisplayID() else { return nil }
        var value: Float = 0.0
        let status = DisplayServicesGetBrightness(id, &value)
        return status == 0 ? value : nil
    }
    
    /// Turns off the built-in display backlight (0.0 nits, hardware-off) for closed-lid mode.
    public func suppressBuiltinBacklight() {
        lock.lock()
        defer { lock.unlock() }
        
        guard !isBacklightSuppressed else { return }
        guard let displayID = getBuiltinDisplayID() else { return }
        
        if let current = readBrightness(for: displayID), current > 0.001 {
            savedBrightnessCache[displayID] = current
        } else if savedBrightnessCache[displayID] == nil {
            savedBrightnessCache[displayID] = 0.65
        }
        
        _ = DisplayServicesSetBrightness(displayID, 0.0)
        isBacklightSuppressed = true
        NSLog("[DisplayController] Built-in display backlight suppressed to 0.0 (saved: %.2f)", savedBrightnessCache[displayID] ?? 0.65)
    }
    
    /// Restores the built-in display backlight to its saved level.
    public func restoreBuiltinBacklight() {
        lock.lock()
        defer { lock.unlock() }
        
        guard isBacklightSuppressed else { return }
        guard let displayID = getBuiltinDisplayID() else { return }
        
        let targetBrightness = savedBrightnessCache[displayID] ?? 0.65
        _ = DisplayServicesSetBrightness(displayID, targetBrightness)
        isBacklightSuppressed = false
        NSLog("[DisplayController] Built-in display backlight restored to %.2f", targetBrightness)
    }
    
    /// Fail-safe emergency restoration on crash or app termination.
    public func emergencyRestore() {
        lock.lock()
        defer { lock.unlock() }
        
        if isBacklightSuppressed, let displayID = getBuiltinDisplayID() {
            let target = savedBrightnessCache[displayID] ?? 0.65
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
