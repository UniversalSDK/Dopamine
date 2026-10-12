import AppKit

public final class AppDelegate: NSObject, NSApplicationDelegate {
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // 1. Активация системы защиты (Anti-Tamper & Anti-Debug)
        AntiTamper.shared.enforceSecurity()
        
        // 2. Системные хуки безопасного завершения
        SignalLifecycleManager.shared.install {
            PowerDisplayEngine.shared.emergencyShutdown()
        }
        
        // 3. Меню в строке состояния
        StatusItemManager.shared.setup()
        
        // 4. Отправка анонимного события запуска (GA4)
        AnalyticsManager.shared.trackAppLaunch()
        
        // 5. Фоновая проверка обновлений (если включено в настройках)
        if UpdateManager.shared.isAutoCheckEnabled {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3.0) {
                UpdateManager.shared.checkForUpdates(manual: false)
            }
        }
        
        NSLog("[AppDelegate] Dopamine v%@ initialized successfully on %@.", UpdateManager.shared.currentVersion, AnalyticsManager.shared.chipModel)
    }
    
    public func applicationWillTerminate(_ notification: Notification) {
        NSLog("[AppDelegate] Terminating Dopamine. Clean shutdown...")
        PowerDisplayEngine.shared.emergencyShutdown()
    }
}
