import Foundation

/// Менеджер настроек Dopamine с сохранением в UserDefaults и нотификациями.
public final class SettingsManager {
    public static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    
    public enum IconStyle: String, CaseIterable {
        case eye = "eye"
        case amphiShield = "amphiShield"
        case pill = "pill"
        case bolt = "bolt"
        case sunMoon = "sunMoon"
        case coffee = "coffee"
        
        public var title: String {
            switch self {
            case .eye: return "Глаз / Око / Eye"
            case .amphiShield: return "Амфи-Щит / Amphi-Shield"
            case .pill: return "Капсула / Capsule"
            case .bolt: return "Молния / Lightning Energy"
            case .sunMoon: return "День и Ночь / Sun & Moon"
            case .coffee: return "Кофе / Кава / Coffee"
            }
        }
    }
    
    private enum Keys {
        static let iconStyle = "iconStyle"
        static let defaultDuration = "defaultDuration"
        static let allowDisplaySleep = "allowDisplaySleep"
        static let preventLidSleep = "preventLidSleep"
        static let turnOffBacklightOnLidClose = "turnOffBacklightOnLidClose"
        static let lockScreenOnLidClose = "lockScreenOnLidClose"
        static let showTimerInMenuBar = "showTimerInMenuBar"
        
        // Аккумулятор и Питание
        static let endSessionOnLowBattery = "endSessionOnLowBattery"
        static let lowBatteryThreshold = "lowBatteryThreshold"
        static let alwaysAskToEndOnLowBattery = "alwaysAskToEndOnLowBattery"
        static let stopSessionOnACDisconnect = "stopSessionOnACDisconnect"
        static let allowOnlyOnAC = "allowOnlyOnAC"
        static let startSessionOnACConnect = "startSessionOnACConnect"
        static let ignoreLowBatteryOnAC = "ignoreLowBatteryOnAC"
    }
    
    public init() {
        registerDefaults()
    }
    
    private func registerDefaults() {
        defaults.register(defaults: [
            Keys.iconStyle: IconStyle.eye.rawValue,
            Keys.defaultDuration: 0, // Бессрочно
            Keys.allowDisplaySleep: true,
            Keys.preventLidSleep: true,
            Keys.turnOffBacklightOnLidClose: true,
            Keys.lockScreenOnLidClose: true,
            Keys.showTimerInMenuBar: false,
            
            // Настройки аккумулятора
            Keys.endSessionOnLowBattery: true,
            Keys.lowBatteryThreshold: 10,
            Keys.alwaysAskToEndOnLowBattery: false,
            Keys.stopSessionOnACDisconnect: false,
            Keys.allowOnlyOnAC: false,
            Keys.startSessionOnACConnect: false,
            Keys.ignoreLowBatteryOnAC: true
        ])
    }
    
    public var iconStyle: IconStyle {
        get {
            let raw = defaults.string(forKey: Keys.iconStyle) ?? IconStyle.eye.rawValue
            return IconStyle(rawValue: raw) ?? .eye
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.iconStyle)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "icon_style", value: newValue.rawValue)
        }
    }
    
    public var defaultDuration: Int {
        get { defaults.integer(forKey: Keys.defaultDuration) }
        set {
            defaults.set(newValue, forKey: Keys.defaultDuration)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "default_duration", value: newValue)
        }
    }
    
    public var allowDisplaySleep: Bool {
        get { defaults.bool(forKey: Keys.allowDisplaySleep) }
        set {
            defaults.set(newValue, forKey: Keys.allowDisplaySleep)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "allow_display_sleep", value: newValue)
        }
    }
    
    public var preventLidSleep: Bool {
        get { defaults.bool(forKey: Keys.preventLidSleep) }
        set {
            defaults.set(newValue, forKey: Keys.preventLidSleep)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "prevent_lid_sleep", value: newValue)
        }
    }
    
    public var turnOffBacklightOnLidClose: Bool {
        get { defaults.bool(forKey: Keys.turnOffBacklightOnLidClose) }
        set {
            defaults.set(newValue, forKey: Keys.turnOffBacklightOnLidClose)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "turn_off_backlight", value: newValue)
        }
    }
    
    public var lockScreenOnLidClose: Bool {
        get { defaults.bool(forKey: Keys.lockScreenOnLidClose) }
        set {
            defaults.set(newValue, forKey: Keys.lockScreenOnLidClose)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "lock_screen", value: newValue)
        }
    }
    
    public var showTimerInMenuBar: Bool {
        get { defaults.bool(forKey: Keys.showTimerInMenuBar) }
        set {
            defaults.set(newValue, forKey: Keys.showTimerInMenuBar)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "show_timer", value: newValue)
        }
    }
    
    // MARK: - Аккумулятор и Сеть
    public var endSessionOnLowBattery: Bool {
        get { defaults.bool(forKey: Keys.endSessionOnLowBattery) }
        set {
            defaults.set(newValue, forKey: Keys.endSessionOnLowBattery)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "end_on_low_battery", value: newValue)
        }
    }
    
    public var lowBatteryThreshold: Int {
        get { defaults.integer(forKey: Keys.lowBatteryThreshold) }
        set {
            defaults.set(newValue, forKey: Keys.lowBatteryThreshold)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "battery_threshold", value: newValue)
        }
    }
    
    public var alwaysAskToEndOnLowBattery: Bool {
        get { defaults.bool(forKey: Keys.alwaysAskToEndOnLowBattery) }
        set {
            defaults.set(newValue, forKey: Keys.alwaysAskToEndOnLowBattery)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "always_ask_low_batt", value: newValue)
        }
    }
    
    public var stopSessionOnACDisconnect: Bool {
        get { defaults.bool(forKey: Keys.stopSessionOnACDisconnect) }
        set {
            defaults.set(newValue, forKey: Keys.stopSessionOnACDisconnect)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "stop_on_ac_disconnect", value: newValue)
        }
    }
    
    public var allowOnlyOnAC: Bool {
        get { defaults.bool(forKey: Keys.allowOnlyOnAC) }
        set {
            defaults.set(newValue, forKey: Keys.allowOnlyOnAC)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "allow_only_on_ac", value: newValue)
        }
    }
    
    public var startSessionOnACConnect: Bool {
        get { defaults.bool(forKey: Keys.startSessionOnACConnect) }
        set {
            defaults.set(newValue, forKey: Keys.startSessionOnACConnect)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "start_on_ac_connect", value: newValue)
        }
    }
    
    public var ignoreLowBatteryOnAC: Bool {
        get { defaults.bool(forKey: Keys.ignoreLowBatteryOnAC) }
        set {
            defaults.set(newValue, forKey: Keys.ignoreLowBatteryOnAC)
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
            AnalyticsManager.shared.trackSettingChange(key: "ignore_battery_on_ac", value: newValue)
        }
    }
}

extension Notification.Name {
    public static let settingsChanged = Notification.Name("DopamineSettingsChanged")
    public static let sessionStateChanged = Notification.Name("DopamineSessionStateChanged")
}
