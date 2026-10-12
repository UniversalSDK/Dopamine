import Foundation
import AppKit

/// Центральный координатор сессий, питания, экрана и аналитики в Dopamine.
public final class PowerDisplayEngine {
    public static let shared = PowerDisplayEngine()
    
    public private(set) var isSessionActive: Bool = false
    public private(set) var sessionStartDate: Date?
    public private(set) var sessionEndDate: Date?
    
    private var sessionTimer: DispatchSourceTimer?
    private let displayController: DisplayController
    private let powerController: PowerAssertionController
    private let clamshellMonitor: ClamshellMonitor
    private let batteryMonitor: BatteryMonitor
    private let settings: SettingsManager
    private let analytics: AnalyticsManager
    
    private var hasPromptedForLowBattery: Bool = false
    
    public init(
        displayController: DisplayController = .shared,
        powerController: PowerAssertionController = .shared,
        clamshellMonitor: ClamshellMonitor = ClamshellMonitor(),
        batteryMonitor: BatteryMonitor = .shared,
        settings: SettingsManager = .shared,
        analytics: AnalyticsManager = .shared
    ) {
        self.displayController = displayController
        self.powerController = powerController
        self.clamshellMonitor = clamshellMonitor
        self.batteryMonitor = batteryMonitor
        self.settings = settings
        self.analytics = analytics
        
        setupObservers()
    }
    
    private func setupObservers() {
        clamshellMonitor.onStateChange = { [weak self] isClosed in
            self?.handleClamshellTransition(isClosed: isClosed)
        }
        
        batteryMonitor.onPowerChange = { [weak self] percent, isAC in
            self?.handlePowerChange(percent: percent, isAC: isAC)
        }
        batteryMonitor.start()
    }
    
    @discardableResult
    public func startSession(durationSeconds: Int = 0) -> Bool {
        guard !isSessionActive else { return true }
        
        if settings.allowOnlyOnAC && !batteryMonitor.isACOnline {
            NSLog("[PowerDisplayEngine] Blocked: allowOnlyOnAC enabled on battery.")
            showNotification(title: "Dopamine", message: TR("ac_only_rule"))
            return false
        }
        
        if settings.endSessionOnLowBattery && !batteryMonitor.isACOnline && batteryMonitor.currentPercent <= settings.lowBatteryThreshold {
            NSLog("[PowerDisplayEngine] Blocked: battery too low.")
            showNotification(title: "Dopamine", message: String(format: TR("low_battery_cutoff"), settings.lowBatteryThreshold))
            return false
        }
        
        isSessionActive = true
        sessionStartDate = Date()
        hasPromptedForLowBattery = false
        
        if durationSeconds > 0 {
            sessionEndDate = Date().addingTimeInterval(TimeInterval(durationSeconds))
            setupDurationTimer(durationSeconds: durationSeconds)
        } else {
            sessionEndDate = nil
        }
        
        powerController.createSessionAssertions(
            allowDisplaySleep: settings.allowDisplaySleep,
            sessionName: "Dopamine Session"
        )
        
        clamshellMonitor.start()
        
        if settings.preventLidSleep {
            powerController.setKernelDisableSleep(true)
        }
        
        if clamshellMonitor.readDirectLidState() {
            handleClamshellTransition(isClosed: true)
        }
        
        analytics.trackSessionStart(durationSeconds: durationSeconds, isAC: batteryMonitor.isACOnline)
        NotificationCenter.default.post(name: .sessionStateChanged, object: nil)
        return true
    }
    
    public func stopSession(reason: String? = nil) {
        guard isSessionActive else { return }
        
        let actualDuration = sessionStartDate.map { Int(Date().timeIntervalSince($0)) } ?? 0
        analytics.trackSessionEnd(durationActual: actualDuration, reason: reason ?? "Manual")
        
        isSessionActive = false
        sessionStartDate = nil
        sessionEndDate = nil
        hasPromptedForLowBattery = false
        
        sessionTimer?.cancel()
        sessionTimer = nil
        
        clamshellMonitor.stop()
        displayController.restoreBuiltinBacklight()
        powerController.cleanup()
        
        if let reason = reason {
            showNotification(title: "Dopamine", message: reason)
        }
        
        NotificationCenter.default.post(name: .sessionStateChanged, object: nil)
    }
    
    public func toggleSession() {
        if isSessionActive {
            stopSession()
        } else {
            startSession(durationSeconds: settings.defaultDuration)
        }
    }
    
    private func setupDurationTimer(durationSeconds: Int) {
        sessionTimer?.cancel()
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now() + .seconds(durationSeconds))
        timer.setEventHandler { [weak self] in
            self?.stopSession(reason: "Timer expired")
        }
        timer.resume()
        sessionTimer = timer
    }
    
    private func handlePowerChange(percent: Int, isAC: Bool) {
        if isSessionActive {
            if !isAC && settings.stopSessionOnACDisconnect {
                stopSession(reason: TR("ac_stop_unplug"))
                return
            }
            
            if settings.endSessionOnLowBattery {
                let isExempt = isAC && settings.ignoreLowBatteryOnAC
                if !isExempt && percent <= settings.lowBatteryThreshold {
                    if settings.alwaysAskToEndOnLowBattery {
                        promptUserForLowBattery(percent: percent)
                    } else {
                        stopSession(reason: String(format: TR("low_batt_title"), percent))
                    }
                    return
                } else if percent > settings.lowBatteryThreshold {
                    hasPromptedForLowBattery = false
                }
            }
        } else {
            if isAC && settings.startSessionOnACConnect {
                startSession(durationSeconds: settings.defaultDuration)
            }
        }
    }
    
    private func promptUserForLowBattery(percent: Int) {
        guard !hasPromptedForLowBattery else { return }
        hasPromptedForLowBattery = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.isSessionActive else { return }
            let alert = NSAlert()
            alert.messageText = String(format: TR("low_batt_title"), percent)
            alert.informativeText = String(format: TR("low_batt_msg"), self.settings.lowBatteryThreshold)
            alert.alertStyle = .warning
            alert.addButton(withTitle: TR("btn_stop"))
            alert.addButton(withTitle: TR("btn_continue"))
            NSApp.activate(ignoringOtherApps: true)
            
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                self.stopSession(reason: "Low battery threshold accepted")
            }
        }
    }
    
    private func handleClamshellTransition(isClosed: Bool) {
        analytics.trackClamshellState(isClosed: isClosed)
        guard isSessionActive else { return }
        
        if isClosed {
            if settings.turnOffBacklightOnLidClose {
                displayController.suppressBuiltinBacklight()
            }
            if settings.lockScreenOnLidClose {
                displayController.lockSession()
            }
        } else {
            displayController.restoreBuiltinBacklight()
        }
    }
    
    private func showNotification(title: String, message: String) {
        DispatchQueue.main.async {
            let notification = NSUserNotification()
            notification.title = title
            notification.informativeText = message
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.deliver(notification)
        }
    }
    
    public func formattedRemainingTime() -> String? {
        guard isSessionActive else { return nil }
        guard let endDate = sessionEndDate else { return TR("indefinite") }
        
        let remaining = max(0, Int(endDate.timeIntervalSinceNow))
        let hours = remaining / 3600
        let minutes = (remaining % 3600) / 60
        let seconds = remaining % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    public func emergencyShutdown() {
        displayController.emergencyRestore()
        powerController.cleanup()
        clamshellMonitor.stop()
        batteryMonitor.stop()
        sessionTimer?.cancel()
        isSessionActive = false
    }
}
