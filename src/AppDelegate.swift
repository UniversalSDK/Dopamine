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
        
        // 5. Проверка первого запуска (First-Run Onboarding)
        // Решает проблему "Тихого запуска" (Silent Launch Trap):
        // При первом запуске мы обязаны показать окно настроек и системное уведомление,
        // чтобы пользователь сразу увидел приложение и понял, что оно активно в menu bar.
        let hasLaunchedKey = "has_launched_before"
        if !UserDefaults.standard.bool(forKey: hasLaunchedKey) {
            UserDefaults.standard.set(true, forKey: hasLaunchedKey)
            AnalyticsManager.shared.trackFirstLaunch()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                PreferencesWindowController.shared.show()
                
                let notification = NSUserNotification()
                notification.title = "Dopamine is Active ⚡️"
                notification.subtitle = "Running in your macOS Menu Bar"
                notification.informativeText = "Close your MacBook lid to test 0.0 nits backlight sleep prevention!"
                notification.soundName = NSUserNotificationDefaultSoundName
                NSUserNotificationCenter.default.deliver(notification)
            }
        }
        
        // 6. Фоновая проверка обновлений (если включено в настройках)
        if UpdateManager.shared.isAutoCheckEnabled {
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 3.0) {
                UpdateManager.shared.checkForUpdates(manual: false)
            }
        }
        
        NSLog("[AppDelegate] Dopamine v%@ initialized successfully on %@.", UpdateManager.shared.currentVersion, AnalyticsManager.shared.chipModel)
    }
    
    public func applicationWillTerminate(_ notification: Notification) {
        NSLog("[AppDelegate] Terminating Dopamine. Clean shutdown...")
        AnalyticsManager.shared.trackAppQuit()
        PowerDisplayEngine.shared.emergencyShutdown()
    }
}
