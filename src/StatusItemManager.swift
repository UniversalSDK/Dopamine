import AppKit

/// Управление иконкой в строке меню, динамическим меню и сменой языка на лету.
public final class StatusItemManager: NSObject, NSMenuDelegate {
    public static let shared = StatusItemManager()
    
    private var statusItem: NSStatusItem!
    private var updateTimer: Timer?
    private let engine = PowerDisplayEngine.shared
    private let settings = SettingsManager.shared
    private let batteryMonitor = BatteryMonitor.shared
    private let localization = LocalizationManager.shared
    
    public override init() {
        super.init()
    }
    
    public func setup() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.target = self
            button.action = #selector(statusItemClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onStateOrLanguageChanged), name: .sessionStateChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateOrLanguageChanged), name: .settingsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onStateOrLanguageChanged), name: .languageChanged, object: nil)
        
        updateIcon()
        startPeriodicTimer()
    }
    
    @objc private func onStateOrLanguageChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.updateIcon()
        }
    }
    
    private func startPeriodicTimer() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimerDisplayIfNeeded()
        }
    }
    
    private func updateTimerDisplayIfNeeded() {
        guard engine.isSessionActive, settings.showTimerInMenuBar else {
            if statusItem.button?.title != "" {
                statusItem.button?.title = ""
            }
            return
        }
        
        if let remaining = engine.formattedRemainingTime() {
            let label = (remaining == TR("indefinite")) ? " ∞" : " \(remaining)"
            statusItem.button?.title = label
        }
    }
    
    public func updateIcon() {
        guard let button = statusItem.button else { return }
        
        let style = settings.iconStyle
        let isActive = engine.isSessionActive
        let sfName: String
        
        switch style {
        case .eye:
            sfName = isActive ? "eye.fill" : "eye.slash"
        case .amphiShield:
            sfName = isActive ? "shield.lefthalf.filled" : "shield"
        case .pill:
            sfName = isActive ? "pill.fill" : "pill"
        case .bolt:
            sfName = isActive ? "bolt.fill" : "bolt.slash"
        case .sunMoon:
            sfName = isActive ? "sun.max.fill" : "moon.zzz.fill"
        case .coffee:
            sfName = isActive ? "cup.and.saucer.fill" : "cup.and.saucer"
        }
        
        if let sf = NSImage(systemSymbolName: sfName, accessibilityDescription: "Dopamine") {
            sf.isTemplate = true
            button.image = sf
            button.imagePosition = .imageLeft
        }
        
        updateTimerDisplayIfNeeded()
    }
    
    @objc private func statusItemClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent
        let isRightClick = event?.type == .rightMouseUp || (event?.modifierFlags.contains(.control) ?? false)
        
        if isRightClick {
            engine.toggleSession()
        } else {
            let menu = buildMenu()
            menu.delegate = self
            statusItem.menu = menu
            statusItem.button?.performClick(nil)
        }
    }
    
    public func menuDidClose(_ menu: NSMenu) {
        DispatchQueue.main.async { [weak self] in
            self?.statusItem.menu = nil
        }
    }
    
    private func buildMenu() -> NSMenu {
        let menu = NSMenu()
        menu.autoenablesItems = false
        
        if engine.isSessionActive {
            let statusItem = NSMenuItem(title: TR("session_active"), action: nil, keyEquivalent: "")
            statusItem.isEnabled = false
            let font = NSFont.boldSystemFont(ofSize: 13)
            statusItem.attributedTitle = NSAttributedString(
                string: TR("session_active"),
                attributes: [.font: font, .foregroundColor: NSColor.systemGreen]
            )
            menu.addItem(statusItem)
            
            if let remaining = engine.formattedRemainingTime() {
                let detailTitle = (remaining == TR("indefinite"))
                    ? TR("session_duration_inf")
                    : String(format: TR("session_remaining"), remaining)
                let detailItem = NSMenuItem(title: "   \(detailTitle)", action: nil, keyEquivalent: "")
                detailItem.isEnabled = false
                menu.addItem(detailItem)
            }
            
            let endItem = NSMenuItem(title: TR("end_session"), action: #selector(endSessionClicked), keyEquivalent: "x")
            endItem.target = self
            menu.addItem(endItem)
            
            menu.addItem(NSMenuItem.separator())
            
            let allowDisplayItem = NSMenuItem(title: TR("allow_display_sleep"), action: #selector(toggleAllowDisplaySleep), keyEquivalent: "")
            allowDisplayItem.target = self
            allowDisplayItem.state = settings.allowDisplaySleep ? .on : .off
            menu.addItem(allowDisplayItem)
            
            let dimLidItem = NSMenuItem(title: TR("cut_backlight"), action: #selector(toggleDimLid), keyEquivalent: "")
            dimLidItem.target = self
            dimLidItem.state = settings.turnOffBacklightOnLidClose ? .on : .off
            menu.addItem(dimLidItem)
        } else {
            let header = NSMenuItem(title: TR("new_session"), action: nil, keyEquivalent: "")
            header.isEnabled = false
            menu.addItem(header)
            
            let indefItem = NSMenuItem(title: TR("indefinite"), action: #selector(startIndefiniteSession), keyEquivalent: "")
            indefItem.target = self
            menu.addItem(indefItem)
            
            // Минуты
            let minutesItem = NSMenuItem(title: TR("minutes"), action: nil, keyEquivalent: "")
            let minutesMenu = NSMenu()
            for m in [5, 10, 15, 20, 25, 30, 45, 50] {
                let item = NSMenuItem(title: String(format: TR("min_suffix"), m), action: #selector(startTimedSession(_:)), keyEquivalent: "")
                item.target = self
                item.tag = m * 60
                minutesMenu.addItem(item)
            }
            minutesItem.submenu = minutesMenu
            menu.addItem(minutesItem)
            
            // Часы
            let hoursItem = NSMenuItem(title: TR("hours"), action: nil, keyEquivalent: "")
            let hoursMenu = NSMenu()
            for h in [1, 2, 3, 4, 6, 8, 12, 24] {
                let item = NSMenuItem(title: String(format: TR("hour_suffix"), h), action: #selector(startTimedSession(_:)), keyEquivalent: "")
                item.target = self
                item.tag = h * 3600
                hoursMenu.addItem(item)
            }
            hoursItem.submenu = hoursMenu
            menu.addItem(hoursItem)
        }
        
        menu.addItem(NSMenuItem.separator())
        
        // Быстрые настройки
        let quickSettingsItem = NSMenuItem(title: TR("quick_settings"), action: nil, keyEquivalent: "")
        let quickMenu = NSMenu()
        
        let qAllowDisplay = NSMenuItem(title: TR("allow_display_sleep"), action: #selector(toggleAllowDisplaySleep), keyEquivalent: "")
        qAllowDisplay.target = self
        qAllowDisplay.state = settings.allowDisplaySleep ? .on : .off
        quickMenu.addItem(qAllowDisplay)
        
        let qPreventLid = NSMenuItem(title: TR("prevent_lid_sleep"), action: #selector(togglePreventLid), keyEquivalent: "")
        qPreventLid.target = self
        qPreventLid.state = settings.preventLidSleep ? .on : .off
        quickMenu.addItem(qPreventLid)
        
        let qDimLid = NSMenuItem(title: TR("cut_backlight"), action: #selector(toggleDimLid), keyEquivalent: "")
        qDimLid.target = self
        qDimLid.state = settings.turnOffBacklightOnLidClose ? .on : .off
        quickMenu.addItem(qDimLid)
        
        let qLockLid = NSMenuItem(title: TR("lock_screen"), action: #selector(toggleLockLid), keyEquivalent: "")
        qLockLid.target = self
        qLockLid.state = settings.lockScreenOnLidClose ? .on : .off
        quickMenu.addItem(qLockLid)
        
        quickMenu.addItem(NSMenuItem.separator())
        
        let qLowBatt = NSMenuItem(title: String(format: TR("low_battery_cutoff"), settings.lowBatteryThreshold), action: #selector(toggleLowBatt), keyEquivalent: "")
        qLowBatt.target = self
        qLowBatt.state = settings.endSessionOnLowBattery ? .on : .off
        quickMenu.addItem(qLowBatt)
        
        let qOnlyOnAC = NSMenuItem(title: TR("ac_only"), action: #selector(toggleOnlyOnAC), keyEquivalent: "")
        qOnlyOnAC.target = self
        qOnlyOnAC.state = settings.allowOnlyOnAC ? .on : .off
        quickMenu.addItem(qOnlyOnAC)
        
        let qStopDisconnect = NSMenuItem(title: TR("ac_disconnect_stop"), action: #selector(toggleStopDisconnect), keyEquivalent: "")
        qStopDisconnect.target = self
        qStopDisconnect.state = settings.stopSessionOnACDisconnect ? .on : .off
        quickMenu.addItem(qStopDisconnect)
        
        quickMenu.addItem(NSMenuItem.separator())
        
        let qLaunchAtLogin = NSMenuItem(title: TR("launch_at_login"), action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        qLaunchAtLogin.target = self
        qLaunchAtLogin.state = LaunchAtLoginHelper.isEnabled ? .on : .off
        quickMenu.addItem(qLaunchAtLogin)
        
        quickMenu.addItem(NSMenuItem.separator())
        
        // Быстрый переключатель языка
        let langMenuItem = NSMenuItem(title: TR("menu_language"), action: nil, keyEquivalent: "")
        let langMenu = NSMenu()
        for lang in LocalizationManager.Language.allCases {
            let item = NSMenuItem(title: lang.title, action: #selector(changeLanguageQuick(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = lang
            item.state = (localization.selectedLanguage == lang) ? .on : .off
            langMenu.addItem(item)
        }
        langMenuItem.submenu = langMenu
        quickMenu.addItem(langMenuItem)
        
        quickSettingsItem.submenu = quickMenu
        menu.addItem(quickSettingsItem)
        
        // Проверка обновлений
        if UpdateManager.shared.isUpdateReadyToInstall, let rel = UpdateManager.shared.stagedRelease {
            let title = (localization.selectedLanguage == .ru)
                ? "⚡️ Установить обновление v\(rel.version)"
                : (localization.selectedLanguage == .uk)
                    ? "⚡️ Встановити оновлення v\(rel.version)"
                    : "⚡️ Install Update v\(rel.version)"
            let updateItem = NSMenuItem(title: title, action: #selector(installPendingUpdate), keyEquivalent: "")
            updateItem.target = self
            let font = NSFont.boldSystemFont(ofSize: 13)
            updateItem.attributedTitle = NSAttributedString(
                string: title,
                attributes: [.font: font, .foregroundColor: NSColor.systemOrange]
            )
            menu.addItem(updateItem)
        } else {
            let updateItem = NSMenuItem(title: TR("check_updates"), action: #selector(checkUpdates), keyEquivalent: "u")
            updateItem.target = self
            menu.addItem(updateItem)
        }
        
        // Настройки
        let prefsItem = NSMenuItem(title: TR("preferences"), action: #selector(openPreferences), keyEquivalent: ",")
        prefsItem.target = self
        menu.addItem(prefsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Статус батареи
        let battSummary = getBatterySummary()
        let battItem = NSMenuItem(title: battSummary, action: nil, keyEquivalent: "")
        battItem.isEnabled = false
        menu.addItem(battItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let aboutItem = NSMenuItem(title: TR("about"), action: #selector(openAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        let quitItem = NSMenuItem(title: TR("quit"), action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        return menu
    }
    
    private func getBatterySummary() -> String {
        batteryMonitor.updateCurrentState()
        let p = batteryMonitor.currentPercent
        let isAC = batteryMonitor.isACOnline
        return isAC ? String(format: TR("status_ac"), p) : String(format: TR("status_battery"), p)
    }
    
    @objc private func startIndefiniteSession() { engine.startSession(durationSeconds: 0) }
    @objc private func startTimedSession(_ sender: NSMenuItem) { engine.startSession(durationSeconds: sender.tag) }
    @objc private func endSessionClicked() { engine.stopSession() }
    
    @objc private func toggleAllowDisplaySleep() {
        settings.allowDisplaySleep.toggle()
        if engine.isSessionActive {
            PowerAssertionController.shared.createSessionAssertions(allowDisplaySleep: settings.allowDisplaySleep, sessionName: "Dopamine Session")
        }
    }
    
    @objc private func togglePreventLid() {
        settings.preventLidSleep.toggle()
        if engine.isSessionActive {
            PowerAssertionController.shared.setKernelDisableSleep(settings.preventLidSleep)
        }
    }
    
    @objc private func toggleDimLid() { settings.turnOffBacklightOnLidClose.toggle() }
    @objc private func toggleLockLid() { settings.lockScreenOnLidClose.toggle() }
    @objc private func toggleLowBatt() { settings.endSessionOnLowBattery.toggle() }
    @objc private func toggleOnlyOnAC() { settings.allowOnlyOnAC.toggle() }
    @objc private func toggleStopDisconnect() { settings.stopSessionOnACDisconnect.toggle() }
    @objc private func toggleLaunchAtLogin() { LaunchAtLoginHelper.isEnabled.toggle() }
    
    @objc private func changeLanguageQuick(_ sender: NSMenuItem) {
        if let lang = sender.representedObject as? LocalizationManager.Language {
            localization.selectedLanguage = lang
        }
    }
    
    @objc private func checkUpdates() {
        UpdateManager.shared.checkForUpdates(manual: true)
    }
    
    @objc private func installPendingUpdate() {
        UpdateManager.shared.applyStagedUpdate()
    }
    
    @objc private func openPreferences() {
        PreferencesWindowController.shared.show()
    }
    
    @objc private func openAbout() {
        let alert = NSAlert()
        alert.messageText = "Dopamine (Apple Silicon Edition)"
        alert.informativeText = "Version \(UpdateManager.shared.currentVersion)\n\nDual-Mode Clamshell & Display Power Engine designed exclusively for Apple Silicon (M1/M2/M3/M4).\n\n• Physical 0.0 nits backlight cutoff on lid close\n• Advanced AC & Battery safeguards\n• Hardened Runtime protection\n\n© 2026 Alexey. All rights reserved."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        NSApp.activate(ignoringOtherApps: true)
        alert.runModal()
    }
    
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
