import Foundation
import IOKit
import IOKit.pwr_mgt

/// Manages system sleep assertions and kernel sleep disabling via pmset.
public final class PowerAssertionController {
    public static let shared = PowerAssertionController()
    
    private var systemSleepAssertionID: IOPMAssertionID = 0
    private var displaySleepAssertionID: IOPMAssertionID = 0
    public private(set) var isKernelSleepDisabled: Bool = false
    
    public init() {}
    
    /// Creates keep-awake assertions.
    /// If allowDisplaySleep is true, only prevents system sleep (allowing display to sleep naturally).
    public func createSessionAssertions(allowDisplaySleep: Bool, sessionName: String = "Amphetamine+ Session") {
        if systemSleepAssertionID == 0 {
            var assertionID: IOPMAssertionID = 0
            let kr = IOPMAssertionCreateWithName(
                kIOPMAssertionTypePreventUserIdleSystemSleep as CFString,
                IOPMAssertionLevel(kIOPMAssertionLevelOn),
                sessionName as CFString,
                &assertionID
            )
            if kr == kIOReturnSuccess {
                systemSleepAssertionID = assertionID
                NSLog("[PowerAssertionController] Created system sleep assertion ID: %u", assertionID)
            }
        }
        
        if !allowDisplaySleep {
            if displaySleepAssertionID == 0 {
                var assertionID: IOPMAssertionID = 0
                let kr = IOPMAssertionCreateWithName(
                    kIOPMAssertionTypePreventUserIdleDisplaySleep as CFString,
                    IOPMAssertionLevel(kIOPMAssertionLevelOn),
                    "\(sessionName) (Display On)" as CFString,
                    &assertionID
                )
                if kr == kIOReturnSuccess {
                    displaySleepAssertionID = assertionID
                    NSLog("[PowerAssertionController] Created display sleep assertion ID: %u", assertionID)
                }
            }
        } else {
            releaseDisplayAssertion()
        }
    }
    
    public func releaseDisplayAssertion() {
        if displaySleepAssertionID != 0 {
            IOPMAssertionRelease(displaySleepAssertionID)
            NSLog("[PowerAssertionController] Released display sleep assertion ID: %u", displaySleepAssertionID)
            displaySleepAssertionID = 0
        }
    }
    
    public func releaseAllAssertions() {
        if systemSleepAssertionID != 0 {
            IOPMAssertionRelease(systemSleepAssertionID)
            NSLog("[PowerAssertionController] Released system sleep assertion ID: %u", systemSleepAssertionID)
            systemSleepAssertionID = 0
        }
        releaseDisplayAssertion()
    }
    
    /// Checks whether macOS kernel currently has SleepDisabled = 1.
    public func queryKernelSleepDisabled() -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        task.arguments = ["-g"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            for line in output.components(separatedBy: "\n") {
                if line.contains("SleepDisabled") {
                    return line.contains("1")
                }
            }
        } catch {
            return false
        }
        return false
    }
    
    /// Enables or disables kernel sleep via passwordless sudoers pmset command.
    @discardableResult
    public func setKernelDisableSleep(_ disabled: Bool) -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
        task.arguments = ["/usr/bin/pmset", "-a", "disablesleep", disabled ? "1" : "0"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            let success = (task.terminationStatus == 0)
            if success {
                isKernelSleepDisabled = disabled
                NSLog("[PowerAssertionController] Set kernel disablesleep to: %d", disabled ? 1 : 0)
            }
            return success
        } catch {
            NSLog("[PowerAssertionController] Failed to set kernel disablesleep: %@", error.localizedDescription)
            return false
        }
    }
    
    /// Full cleanup of assertions and pmset states back to macOS defaults.
    public func cleanup() {
        releaseAllAssertions()
        if isKernelSleepDisabled || queryKernelSleepDisabled() {
            _ = setKernelDisableSleep(false)
        }
    }
}
