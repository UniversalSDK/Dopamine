import Foundation
import ServiceManagement

/// Помощник управления автозапуском Dopamine при старте macOS (Login Items).
/// Использует современный Apple API SMAppService (macOS 13.0+) с корректной регистрацией в Системных настройках.
public final class LaunchAtLoginHelper {
    
    public static var isEnabled: Bool {
        get {
            if #available(macOS 13.0, *) {
                return SMAppService.mainApp.status == .enabled
            } else {
                return UserDefaults.standard.bool(forKey: "launchAtLoginFallback")
            }
        }
        set {
            if #available(macOS 13.0, *) {
                do {
                    if newValue {
                        if SMAppService.mainApp.status != .enabled {
                            try SMAppService.mainApp.register()
                            NSLog("[LaunchAtLogin] Registered main app as login item.")
                        }
                    } else {
                        if SMAppService.mainApp.status == .enabled {
                            try SMAppService.mainApp.unregister()
                            NSLog("[LaunchAtLogin] Unregistered main app from login items.")
                        }
                    }
                } catch {
                    NSLog("[LaunchAtLogin] Failed to change login item status: %@", error.localizedDescription)
                }
            } else {
                UserDefaults.standard.set(newValue, forKey: "launchAtLoginFallback")
            }
            AnalyticsManager.shared.trackSettingChange(key: "launch_at_login", value: newValue ? 1 : 0)
        }
    }
}
