import Foundation

/// Легковесный менеджер телеметрии Google Analytics 4 через Measurement Protocol.
/// Работает без тяжелых SDK, без блокировок потока, уважая приватность.
public final class AnalyticsManager {
    public static let shared = AnalyticsManager()
    
    // Боевые идентификаторы Google Analytics 4 (Property: LidGuard, properties/558520491)
    public var measurementId: String = "G-RNJ3Q6WE3B"
    public var apiSecret: String = "IYM1um45RHWx-9_6BqBI7Q"
    
    private let clientIdKey = "analytics_client_id"
    private let enabledKey = "analytics_enabled"
    private let session = URLSession(configuration: .ephemeral)
    
    // Поддержка сессий GA4 (Measurement Protocol требует session_id для подсчета activeUsers и sessions)
    private var currentSessionId: Int64 = Int64(Date().timeIntervalSince1970)
    private var lastEventTimestamp: TimeInterval = Date().timeIntervalSince1970
    
    public init() {}
    
    public var sessionId: Int64 {
        let now = Date().timeIntervalSince1970
        // Если прошло более 30 минут бездействия — генерируем новый session_id (стандарт GA4)
        if now - lastEventTimestamp > 1800 {
            currentSessionId = Int64(now)
        }
        lastEventTimestamp = now
        return currentSessionId
    }
    
    public var isEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: enabledKey) == nil {
                return true // По умолчанию включено с возможностью отключения
            }
            return UserDefaults.standard.bool(forKey: enabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: enabledKey)
        }
    }
    
    public var clientId: String {
        if let id = UserDefaults.standard.string(forKey: clientIdKey) {
            return id
        }
        let newId = UUID().uuidString
        UserDefaults.standard.set(newId, forKey: clientIdKey)
        return newId
    }
    
    /// Модель чипа Apple Silicon (M1, M1 Pro, M2, M3, M4)
    public var chipModel: String {
        var size = 0
        sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: size)
        sysctlbyname("machdep.cpu.brand_string", &machine, &size, nil, 0)
        let brand = String(cString: machine).trimmingCharacters(in: .whitespacesAndNewlines)
        return brand.isEmpty ? "Apple Silicon" : brand
    }
    
    /// Версия macOS (например, "15.0.1")
    public var macOSVersion: String {
        return ProcessInfo.processInfo.operatingSystemVersionString
    }
    
    /// Отправка события в GA4 Measurement Protocol
    public func trackEvent(name: String, parameters: [String: Any] = [:], synchronous: Bool = false) {
        guard isEnabled else { return }
        
        var eventParams: [String: Any] = parameters
        eventParams["session_id"] = sessionId
        eventParams["app_name"] = "Dopamine"
        eventParams["chip"] = chipModel
        eventParams["os_version"] = macOSVersion
        eventParams["app_version"] = "1.2.2"
        eventParams["locale"] = LocalizationManager.shared.activeCode
        if eventParams["engagement_time_msec"] == nil {
            eventParams["engagement_time_msec"] = 1000
        }
        
        let payload: [String: Any] = [
            "client_id": clientId,
            "events": [
                [
                    "name": name,
                    "params": eventParams
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
            return
        }
        
        let urlString = "https://www.google-analytics.com/mp/collect?api_secret=\(apiSecret)&measurement_id=\(measurementId)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.timeoutInterval = synchronous ? 2.0 : 10.0
        
        if synchronous {
            let semaphore = DispatchSemaphore(value: 0)
            let task = session.dataTask(with: request) { _, _, _ in
                semaphore.signal()
            }
            task.resume()
            _ = semaphore.wait(timeout: .now() + 1.5)
        } else {
            let task = session.dataTask(with: request) { _, response, error in
                if let error = error {
                    NSLog("[Analytics] Failed to send event %@: %@", name, error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    NSLog("[Analytics] Event %@ dispatched (status: %d)", name, httpResponse.statusCode)
                }
            }
            task.resume()
        }
    }
    
    // Быстрые методы для ключевых событий
    public func trackAppLaunch() {
        trackEvent(name: "app_launch")
    }
    
    public func trackFirstLaunch() {
        trackEvent(name: "first_launch")
    }
    
    public func trackAppQuit() {
        trackEvent(name: "app_quit", synchronous: true)
    }
    
    public func trackPreferencesOpen() {
        trackEvent(name: "preferences_open")
    }
    
    public func trackSessionStart(durationSeconds: Int, isAC: Bool) {
        trackEvent(name: "session_start", parameters: [
            "duration": durationSeconds,
            "is_ac": isAC ? 1 : 0
        ])
    }
    
    public func trackSessionEnd(durationActual: Int, reason: String) {
        trackEvent(name: "session_end", parameters: [
            "duration_actual": durationActual,
            "reason": reason
        ])
    }
    
    public func trackClamshellState(isClosed: Bool) {
        trackEvent(name: isClosed ? "lid_closed" : "lid_opened")
    }
    
    public func trackSettingChange(key: String, value: Any) {
        trackEvent(name: "setting_change", parameters: [
            "key": key,
            "value": "\(value)"
        ])
    }
}
