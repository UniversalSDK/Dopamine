import Foundation

/// Менеджер лицензирования и монетизации (Free / Early Adopter -> Pro Paywall).
/// Хранит данные локально в изолированном контейнере UserDefaults приложения.
/// Не запрашивает доступ к Связке ключей macOS (Keychain Access), чтобы никогда не пугать пользователя системными диалогами ввода пароля.
public final class LicenseManager {
    public static let shared = LicenseManager()
    
    public enum LicenseTier: String {
        case free = "free"
        case earlyAdopter = "early_adopter" // Бесплатный доступ для ранних пользователей
        case pro = "pro"
    }
    
    private let defaults = UserDefaults.standard
    private let tierKey = "dopamine_license_tier"
    private let licenseKeyStore = "dopamine_license_key"
    
    public init() {
        if defaults.string(forKey: tierKey) == nil {
            defaults.set(LicenseTier.earlyAdopter.rawValue, forKey: tierKey)
        }
    }
    
    public var currentTier: LicenseTier {
        if let raw = defaults.string(forKey: tierKey), let tier = LicenseTier(rawValue: raw) {
            return tier
        }
        return .earlyAdopter
    }
    
    /// Активен ли Pro-функционал
    public var isProActive: Bool {
        switch currentTier {
        case .pro, .earlyAdopter:
            return true
        case .free:
            return false
        }
    }
    
    /// Валидация лицензионного ключа (Lemon Squeezy / Gumroad / собственный формат)
    public func validateLicenseKey(_ key: String, completion: @escaping (Bool, String) -> Void) {
        let cleaned = key.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Базовая валидация структуры ключа (например: DP-XXXX-XXXX-XXXX)
        guard cleaned.hasPrefix("DP-") || cleaned.hasPrefix("AG-") || cleaned.hasPrefix("LG-") || cleaned.count >= 16 else {
            completion(false, "Неверный формат лицензионного ключа.")
            return
        }
        
        defaults.set(cleaned, forKey: licenseKeyStore)
        defaults.set(LicenseTier.pro.rawValue, forKey: tierKey)
        AnalyticsManager.shared.trackEvent(name: "license_activated", parameters: ["tier": "pro"])
        completion(true, "Лицензия Pro успешно активирована!")
    }
    
    public func getSavedLicenseKey() -> String? {
        return defaults.string(forKey: licenseKeyStore)
    }
}
