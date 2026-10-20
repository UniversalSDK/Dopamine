import AppKit
import Foundation
import CommonCrypto

/// Менеджер проверки, фоновой загрузки и бесшовного тихого обновления (Silent In-Place Auto-Updater).
public final class UpdateManager {
    public static let shared = UpdateManager()
    
    // Первичный и резервный URL манифеста версий
    public var primaryManifestURL: String = "https://dopamine.33rd.pro/latest.json"
    public var fallbackManifestURL: String = "https://raw.githubusercontent.com/UniversalSDK/Dopamine/main/releases/latest.json"
    
    public struct ReleaseInfo: Codable {
        public let version: String
        public let build: Int
        public let releaseNotes: String
        public let downloadUrl: String
        public let zipUrl: String?
        public let sha256: String?
        public let zipSha256: String?
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
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2.1"
    }
    
    public var currentBuild: Int {
        if let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String, let bi = Int(b) {
            return bi
        }
        return 13
    }
    
    // Статус готового к установке фонового обновления
    public private(set) var isUpdateReadyToInstall: Bool = false
    public private(set) var stagedRelease: ReleaseInfo?
    private var stagedAppPath: String?
    
    private var isDownloading: Bool = false
    
    public init() {}
    
    // MARK: - Проверка обновлений
    
    public func checkForUpdates(manual: Bool = false) {
        fetchManifest(from: primaryManifestURL) { [weak self] release in
            if let release = release {
                self?.processRelease(release, manual: manual)
            } else {
                // Fallback to GitHub raw
                guard let self = self else { return }
                self.fetchManifest(from: self.fallbackManifestURL) { fallbackRelease in
                    if let fallbackRelease = fallbackRelease {
                        self.processRelease(fallbackRelease, manual: manual)
                    } else if manual {
                        DispatchQueue.main.async {
                            self.showAlert(
                                title: TR("check_updates"),
                                message: String(format: TR("update_err_network"), "Host unreachable")
                            )
                        }
                    }
                }
            }
        }
    }
    
    private func fetchManifest(from urlString: String, completion: @escaping (ReleaseInfo?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        var req = URLRequest(url: url)
        req.cachePolicy = .reloadIgnoringLocalCacheData
        req.timeoutInterval = 8.0
        
        let task = URLSession.shared.dataTask(with: req) { data, response, error in
            guard let data = data, error == nil,
                  let release = try? JSONDecoder().decode(ReleaseInfo.self, from: data) else {
                completion(nil)
                return
            }
            completion(release)
        }
        task.resume()
    }
    
    private func processRelease(_ release: ReleaseInfo, manual: Bool) {
        if isNewer(release.version, than: currentVersion) || (release.version == currentVersion && release.build > currentBuild) {
            NSLog("[UpdateManager] Newer release found: v%@ (build %d)", release.version, release.build)
            
            if isUpdateReadyToInstall && stagedRelease?.version == release.version {
                // Уже загружено в фоне и готово к установке
                DispatchQueue.main.async {
                    self.showReadyToInstallDialog(release: release)
                }
                return
            }
            
            if manual {
                DispatchQueue.main.async {
                    self.showUpdateAvailableDialog(release: release)
                }
            } else {
                // Фоновая автоматическая загрузка без беспокойства пользователя
                downloadAndStageUpdate(release: release, silent: true)
            }
        } else if manual {
            DispatchQueue.main.async {
                self.showAlert(
                    title: TR("check_updates"),
                    message: String(format: TR("update_latest"), self.currentVersion)
                )
            }
        }
    }
    
    /// Сравнение версий
    public func isNewer(_ remote: String, than current: String) -> Bool {
        return remote.compare(current, options: .numeric) == .orderedDescending
    }
    
    // MARK: - Диалоги пользователю
    
    private func showUpdateAvailableDialog(release: ReleaseInfo) {
        let alert = NSAlert()
        alert.messageText = String(format: TR("update_available_title"), release.version)
        alert.informativeText = String(format: TR("update_available_msg"), currentVersion, release.version, release.releaseNotes)
        alert.alertStyle = .informational
        
        // Кнопка 1: Установить в один клик
        let btnTitle = (LocalizationManager.shared.selectedLanguage == .ru)
            ? "Обновить и перезапустить"
            : (LocalizationManager.shared.selectedLanguage == .uk)
                ? "Оновити та перезапустити"
                : "Update & Relaunch"
        alert.addButton(withTitle: btnTitle)
        // Кнопка 2: Напомнить позже
        alert.addButton(withTitle: TR("btn_remind_later"))
        
        NSApp.activate(ignoringOtherApps: true)
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            downloadAndStageUpdate(release: release, silent: false)
        }
    }
    
    private func showReadyToInstallDialog(release: ReleaseInfo) {
        let alert = NSAlert()
        alert.messageText = String(format: TR("update_available_title"), release.version)
        let isRu = LocalizationManager.shared.selectedLanguage == .ru
        let isUk = LocalizationManager.shared.selectedLanguage == .uk
        let msg = isRu
            ? "Обновление Dopamine v\(release.version) уже загружено и готово к установке.\n\nПерезапустить приложение прямо сейчас?"
            : isUk
                ? "Оновлення Dopamine v\(release.version) вже завантажено і готове до встановлення.\n\nПерезапустити застосунок зараз?"
                : "Dopamine v\(release.version) has been downloaded and is ready to install.\n\nRelaunch application now?"
        alert.informativeText = msg
        alert.alertStyle = .informational
        let restartBtn = isRu ? "Перезапустить сейчас" : isUk ? "Перезапустити зараз" : "Relaunch Now"
        alert.addButton(withTitle: restartBtn)
        alert.addButton(withTitle: TR("btn_remind_later"))
        
        NSApp.activate(ignoringOtherApps: true)
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            applyStagedUpdate()
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
    
    // MARK: - Фоновое скачивание и распаковка (Silent Staging)
    
    public func downloadAndStageUpdate(release: ReleaseInfo, silent: Bool) {
        guard !isDownloading else { return }
        isDownloading = true
        
        let fileUrlString = release.zipUrl ?? release.downloadUrl
        guard let downloadUrl = URL(string: fileUrlString) else {
            isDownloading = false
            return
        }
        
        NSLog("[UpdateManager] Starting update download from: %@", downloadUrl.absoluteString)
        
        let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let updateDir = cachesDir.appendingPathComponent("com.alexey.Dopamine/Updates/v\(release.version)", isDirectory: true)
        
        try? FileManager.default.createDirectory(at: updateDir, withIntermediateDirectories: true)
        
        let task = URLSession.shared.downloadTask(with: downloadUrl) { [weak self] tempLocalUrl, response, error in
            guard let self = self else { return }
            self.isDownloading = false
            
            guard let tempLocalUrl = tempLocalUrl, error == nil else {
                NSLog("[UpdateManager] Download failed: %@", error?.localizedDescription ?? "unknown error")
                if !silent {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Download Error", message: error?.localizedDescription ?? "Failed to download update.")
                    }
                }
                return
            }
            
            let isZip = fileUrlString.hasSuffix(".zip")
            let destFile = updateDir.appendingPathComponent(isZip ? "Dopamine.zip" : "Dopamine.dmg")
            try? FileManager.default.removeItem(at: destFile)
            
            do {
                try FileManager.default.moveItem(at: tempLocalUrl, to: destFile)
                
                // Проверка SHA256 (если указан в манифесте)
                let expectedSha = release.zipSha256 ?? release.sha256
                if let expected = expectedSha, !expected.isEmpty {
                    let actualSha = self.computeSHA256(url: destFile)
                    if actualSha.lowercased() != expected.lowercased() {
                        NSLog("[UpdateManager] SHA256 mismatch! expected: %@, got: %@", expected, actualSha)
                        if !silent {
                            DispatchQueue.main.async {
                                self.showAlert(title: "Security Check Failed", message: "Checksum does not match.")
                            }
                        }
                        return
                    }
                }
                
                // Распаковка .zip
                if isZip {
                    let stagedApp = updateDir.appendingPathComponent("Dopamine.app")
                    try? FileManager.default.removeItem(at: stagedApp)
                    
                    let unzipTask = Process()
                    unzipTask.executableURL = URL(fileURLWithPath: "/usr/bin/ditto")
                    unzipTask.arguments = ["-xk", destFile.path, updateDir.path]
                    try unzipTask.run()
                    unzipTask.waitUntilExit()
                    
                    if FileManager.default.fileExists(atPath: stagedApp.path) {
                        self.isUpdateReadyToInstall = true
                        self.stagedRelease = release
                        self.stagedAppPath = stagedApp.path
                        NSLog("[UpdateManager] Update staged successfully at: %@", stagedApp.path)
                        
                        if !silent {
                            DispatchQueue.main.async {
                                self.applyStagedUpdate()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.notifyUserUpdateReady(release: release)
                            }
                        }
                    }
                } else {
                    // Если это DMG, открываем его для пользователя
                    if !silent {
                        DispatchQueue.main.async {
                            NSWorkspace.shared.open(destFile)
                        }
                    }
                }
            } catch {
                NSLog("[UpdateManager] Staging error: %@", error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func notifyUserUpdateReady(release: ReleaseInfo) {
        let isRu = LocalizationManager.shared.selectedLanguage == .ru
        let isUk = LocalizationManager.shared.selectedLanguage == .uk
        let msg = isRu
            ? "Обновление готово к установке. Нажмите для перезапуска."
            : isUk
                ? "Оновлення готове до встановлення. Натисніть для перезапуску."
                : "Update ready to install. Click to restart."
        
        let notification = NSUserNotification()
        notification.title = "Dopamine v\(release.version)"
        notification.informativeText = msg
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    // MARK: - Атомарная замена и перезапуск (In-Place Swap)
    
    public func applyStagedUpdate() {
        guard let stagedApp = stagedAppPath,
              FileManager.default.fileExists(atPath: stagedApp) else {
            return
        }
        
        let targetAppPath = Bundle.main.bundleURL.path
        let currentPid = ProcessInfo.processInfo.processIdentifier
        
        NSLog("[UpdateManager] Executing in-place update: %@ -> %@ (pid: %d)", stagedApp, targetAppPath, currentPid)
        
        let updaterScript = """
        #!/bin/bash
        TARGET="\(targetAppPath)"
        STAGED="\(stagedApp)"
        PID="\(currentPid)"
        
        # Ожидание выхода текущего процесса
        while kill -0 "$PID" 2>/dev/null; do
            sleep 0.1
        done
        
        # Атомарная подмена бандла
        if [ -d "$STAGED" ] && [ -n "$TARGET" ]; then
            rm -rf "$TARGET"
            cp -R "$STAGED" "$TARGET"
            xattr -dr com.apple.quarantine "$TARGET" 2>/dev/null || true
            rm -rf "$(dirname "$STAGED")"
            open "$TARGET"
        fi
        """
        
        let scriptPath = "/tmp/dopamine_updater.sh"
        try? updaterScript.write(toFile: scriptPath, atomically: true, encoding: .utf8)
        
        let chmodTask = Process()
        chmodTask.executableURL = URL(fileURLWithPath: "/bin/chmod")
        chmodTask.arguments = ["+x", scriptPath]
        try? chmodTask.run()
        chmodTask.waitUntilExit()
        
        // Запуск detached updater скрипта
        let launchTask = Process()
        launchTask.executableURL = URL(fileURLWithPath: "/bin/bash")
        launchTask.arguments = [scriptPath]
        try? launchTask.run()
        
        // Безопасное завершение приложения
        DispatchQueue.main.async {
            NSApp.terminate(nil)
        }
    }
    
    // MARK: - Хеширование
    
    private func computeSHA256(url: URL) -> String {
        guard let handle = try? FileHandle(forReadingFrom: url) else { return "" }
        defer { handle.closeFile() }
        var ctx = CC_SHA256_CTX()
        CC_SHA256_Init(&ctx)
        while autoreleasepool(invoking: {
            let data = handle.readData(ofLength: 65536)
            if data.isEmpty { return false }
            data.withUnsafeBytes { ptr in
                _ = CC_SHA256_Update(&ctx, ptr.baseAddress, CC_LONG(data.count))
            }
            return true
        }) {}
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256_Final(&digest, &ctx)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
