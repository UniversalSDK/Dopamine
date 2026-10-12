import Foundation
import IOKit.ps

/// Мониторинг состояния аккумулятора и источника питания (Сеть / Батарея).
public final class BatteryMonitor {
    public static let shared = BatteryMonitor()
    
    public typealias BatteryCallback = (_ percent: Int, _ isAC: Bool) -> Void
    
    public private(set) var currentPercent: Int = 100
    public private(set) var isACOnline: Bool = true
    public private(set) var isBatteryPresent: Bool = true
    
    private var runLoopSource: CFRunLoopSource?
    private var watchdogTimer: Timer?
    public var onPowerChange: BatteryCallback?
    
    public init() {
        updateCurrentState()
    }
    
    public func start() {
        // 1. Системный слушатель IOKit Power Sources
        let context = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        if let source = IOPSNotificationCreateRunLoopSource({ context in
            guard let context = context else { return }
            let monitor = Unmanaged<BatteryMonitor>.fromOpaque(context).takeUnretainedValue()
            monitor.handlePowerEvent()
        }, context)?.takeRetainedValue() {
            CFRunLoopAddSource(CFRunLoopGetMain(), source, .defaultMode)
            self.runLoopSource = source
        }
        
        // 2. Сторожевой таймер раз в 5 секунд (для гарантии отслеживания падения процента)
        watchdogTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateCurrentState()
        }
    }
    
    public func updateCurrentState() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef] else {
            return
        }
        
        var foundBattery = false
        for ps in sources {
            if let desc = IOPSGetPowerSourceDescription(snapshot, ps)?.takeUnretainedValue() as? [String: Any] {
                foundBattery = true
                let percent = desc[kIOPSCurrentCapacityKey] as? Int ?? 100
                let state = desc[kIOPSPowerSourceStateKey] as? String ?? ""
                let isAC = (state == kIOPSACPowerValue)
                
                let percentChanged = (percent != currentPercent)
                let acChanged = (isAC != isACOnline)
                
                self.currentPercent = percent
                self.isACOnline = isAC
                self.isBatteryPresent = true
                
                if percentChanged || acChanged {
                    NSLog("[BatteryMonitor] Battery state updated: %d%%, AC Online: %d", percent, isAC ? 1 : 0)
                    DispatchQueue.main.async { [weak self] in
                        self?.onPowerChange?(percent, isAC)
                    }
                }
                break
            }
        }
        
        if !foundBattery {
            self.isBatteryPresent = false
            self.isACOnline = true
            self.currentPercent = 100
        }
    }
    
    private func handlePowerEvent() {
        DispatchQueue.main.async { [weak self] in
            self?.updateCurrentState()
        }
    }
    
    public func stop() {
        watchdogTimer?.invalidate()
        watchdogTimer = nil
        
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), source, .defaultMode)
            self.runLoopSource = nil
        }
    }
    
    deinit {
        stop()
    }
}
