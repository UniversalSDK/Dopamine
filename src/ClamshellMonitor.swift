import Foundation
import IOKit
import IOKit.pwr_mgt

/// Monitors MacBook clamshell (lid) open/close state via IOKit kernel events and a watchdog timer.
public final class ClamshellMonitor {
    public typealias StateChangeCallback = (_ isLidClosed: Bool) -> Void
    
    // kIOPMMessageClamshellStateChange = iokit_family_msg(sub_iokit_powermanagement, 0x100)
    private static let kIOPMMessageClamshellStateChange: UInt32 = 0xe0034100
    
    private var notifyPort: IONotificationPortRef?
    private var notificationObj: io_object_t = 0
    private var rootDomain: io_service_t = 0
    private var watchdogTimer: DispatchSourceTimer?
    private let monitorQueue = DispatchQueue(label: "com.amphetamineplus.clamshell", qos: .userInteractive)
    
    public private(set) var isLidClosed: Bool = false
    public var onStateChange: StateChangeCallback?
    
    private var debounceWorkItem: DispatchWorkItem?
    
    public init() {
        self.isLidClosed = readDirectLidState()
    }
    
    public func start() {
        monitorQueue.async { [weak self] in
            guard let self = self else { return }
            self.setupIOKitNotification()
            let current = self.readDirectLidState()
            self.isLidClosed = current
            let callback = self.onStateChange
            DispatchQueue.main.async {
                callback?(current)
            }
        }
    }
    
    /// Queries the AppleClamshellState property directly from IOPMrootDomain hardware.
    public static func readDirectHardwareLidState() -> Bool {
        let domain = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPMrootDomain"))
        guard domain != 0 else { return false }
        defer { IOObjectRelease(domain) }
        
        guard let prop = IORegistryEntryCreateCFProperty(
            domain,
            "AppleClamshellState" as CFString,
            kCFAllocatorDefault,
            0
        )?.takeRetainedValue() else {
            return false
        }
        
        if let boolVal = prop as? Bool {
            return boolVal
        } else if let numVal = prop as? NSNumber {
            return numVal.boolValue
        }
        return false
    }
    
    public func readDirectLidState() -> Bool {
        return Self.readDirectHardwareLidState()
    }
    
    private func setupIOKitNotification() {
        rootDomain = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPMrootDomain"))
        guard rootDomain != 0 else { return }
        
        notifyPort = IONotificationPortCreate(kIOMainPortDefault)
        guard let notifyPort = notifyPort else { return }
        
        IONotificationPortSetDispatchQueue(notifyPort, monitorQueue)
        
        let callback: IOServiceInterestCallback = { refcon, _, messageType, argument in
            guard let refcon = refcon else { return }
            let monitor = Unmanaged<ClamshellMonitor>.fromOpaque(refcon).takeUnretainedValue()
            monitor.handleInterestMessage(messageType: messageType, argument: argument)
        }
        
        let selfPtr = Unmanaged.passUnretained(self).toOpaque()
        _ = IOServiceAddInterestNotification(
            notifyPort,
            rootDomain,
            kIOGeneralInterest,
            callback,
            selfPtr,
            &notificationObj
        )
    }
    
    private func handleInterestMessage(messageType: UInt32, argument: UnsafeMutableRawPointer?) {
        if messageType == Self.kIOPMMessageClamshellStateChange {
            scheduleStateCheck()
        }
    }
    
    private func scheduleStateCheck() {
        debounceWorkItem?.cancel()
        let item = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let verifiedState = Self.readDirectHardwareLidState()
            if verifiedState != self.isLidClosed {
                self.isLidClosed = verifiedState
                NSLog("[ClamshellMonitor] Hardware lid state settled to: %@", verifiedState ? "CLOSED" : "OPEN")
                let callback = self.onStateChange
                DispatchQueue.main.async {
                    callback?(verifiedState)
                }
            }
        }
        debounceWorkItem = item
        monitorQueue.asyncAfter(deadline: .now() + 0.15, execute: item)
    }
    
    public func stop() {
        monitorQueue.sync {
            debounceWorkItem?.cancel()
            debounceWorkItem = nil
            
            if notificationObj != 0 {
                IOObjectRelease(notificationObj)
                notificationObj = 0
            }
            if rootDomain != 0 {
                IOObjectRelease(rootDomain)
                rootDomain = 0
            }
            if let notifyPort = notifyPort {
                IONotificationPortDestroy(notifyPort)
                self.notifyPort = nil
            }
        }
    }
    
    deinit {
        stop()
    }
}
