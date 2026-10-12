import Foundation
import Security

/// Менеджер лицензирования и монетизации (Free / Early Adopter -> Pro Paywall).
/// Позволяет плавно перевести пользователей с бесплатной версии на платную.
public final class LicenseManager {
    public static let shared = LicenseManager()
    
    public enum LicenseTier: String {
        case free = "free"
        case earlyAdopter = "early_adopter" // Бесплатный доступ для ранних пользователей
        case pro = "pro"
    }
    
    private let keychainService = "com.alexey.Dopamine.License"
    private let keychainAccount = "LicenseKey"
    private let keychainTierAccount = "LicenseTier"
    private let tierKey = "license_tier"
    
    public init() {
        // Проверяем статус в Keychain
        if getSavedTierFromKeychain() == nil {
            saveTierToKeychain(tier: .earlyAdopter)
        }
    }
    
    public var currentTier: LicenseTier {
        if let saved = getSavedTierFromKeychain() {
            return saved
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
        
        // Базовая валидация структуры ключа (например: AG-XXXX-XXXX-XXXX)
        guard cleaned.hasPrefix("AG-") || cleaned.hasPrefix("LG-") || cleaned.count >= 16 else {
            completion(false, "Неверный формат лицензионного ключа.")
            return
        }
        
        // В продакшене здесь выполняется защищенный HTTPS POST запрос к Lemon Squeezy API
        // https://api.lemonsqueezy.com/v1/licenses/activate
        // Для демонстрации и локальной проверки:
        saveLicenseToKeychain(key: cleaned)
        saveTierToKeychain(tier: .pro)
        completion(true, "Лицензия Pro успешно активирована!")
    }
    
    // MARK: - Безопасное хранение в Keychain
    private func saveTierToKeychain(tier: LicenseTier) {
        guard let data = tier.rawValue.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainTierAccount
        ]
        SecItemDelete(query as CFDictionary)
        var newQuery = query
        newQuery[kSecValueData as String] = data
        SecItemAdd(newQuery as CFDictionary, nil)
    }
    
    private func getSavedTierFromKeychain() -> LicenseTier? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainTierAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data, let raw = String(data: data, encoding: .utf8) {
            return LicenseTier(rawValue: raw)
        }
        return nil
    }
    
    private func saveLicenseToKeychain(key: String) {
        guard let data = key.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        
        SecItemDelete(query as CFDictionary)
        
        var newQuery = query
        newQuery[kSecValueData as String] = data
        SecItemAdd(newQuery as CFDictionary, nil)
    }
    
    public func getSavedLicenseKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
