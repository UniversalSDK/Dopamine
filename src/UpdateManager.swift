import AppKit

/// Менеджер проверки и доставки обновлений приложения.
public final class UpdateManager {
    public static let shared = UpdateManager()
    
    // URL манифеста версий (можно настроить на ваш сервер или GitHub raw URL)
    public var updateManifestURL: String = "https://raw.githubusercontent.com/alexey/Dopamine/main/releases/latest.json"
    
    public struct ReleaseInfo: Codable {
        public let version: String
        public let build: Int
        public let releaseNotes: String
        public let downloadUrl: String
        public let isCritical: Bool?
    }
    
    private let autoCheckKey = "autoCheckUpdates"
    
    public var isAutoCheckEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: autoCheckKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: autoCheckKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: autoCheckKey)
        }
    }
    
    public var currentVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2.0"
    }
    
    public func checkForUpdates(manual: Bool = false) {
        guard let url = URL(string: updateManifestURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                if manual {
                    DispatchQueue.main.async {
                        self.showAlert(title: TR("check_updates"), message: String(format: TR("update_err_network"), error.localizedDescription))
                    }
                }
                return
            }
            
            guard let data = data,
                  let release = try? JSONDecoder().decode(ReleaseInfo.self, from: data) else {
                if manual {
                    DispatchQueue.main.async {
                        self.showAlert(title: TR("check_updates"), message: String(format: TR("update_latest"), self.currentVersion))
                    }
                }
                return
            }
            
            if self.isNewer(release.version, than: self.currentVersion) {
                DispatchQueue.main.async {
                    self.showUpdateAvailableDialog(release: release)
                }
            } else if manual {
                DispatchQueue.main.async {
                    self.showAlert(title: TR("check_updates"), message: String(format: TR("update_latest"), self.currentVersion))
                }
            }
        }
        task.resume()
    }
    
    /// Сравнение семантических версий (1.3.0 > 1.2.0)
    private func isNewer(_ remote: String, than current: String) -> Bool {
        return remote.compare(current, options: .numeric) == .orderedDescending
    }
    
    private func showUpdateAvailableDialog(release: ReleaseInfo) {
        let alert = NSAlert()
        alert.messageText = String(format: TR("update_available_title"), release.version)
        alert.informativeText = String(format: TR("update_available_msg"), currentVersion, release.version, release.releaseNotes)
        alert.alertStyle = .informational
        alert.addButton(withTitle: TR("btn_download"))
        alert.addButton(withTitle: TR("btn_remind_later"))
        
        NSApp.activate(ignoringOtherApps: true)
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let downloadUrl = URL(string: release.downloadUrl) {
                NSWorkspace.shared.open(downloadUrl)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: TR("btn_ok"))
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
    }
}
