import AppKit

/// Окно настроек LidGuard с поддержкой динамической смены языка (EN / UK / RU),
/// проверки обновлений и управления приватностью аналитики.
public final class PreferencesWindowController: NSWindowController {
    public static let shared = PreferencesWindowController()
    
    private let settings = SettingsManager.shared
    private let batteryMonitor = BatteryMonitor.shared
    private let localization = LocalizationManager.shared
    private let updateManager = UpdateManager.shared
    private let analytics = AnalyticsManager.shared
    private let license = LicenseManager.shared
    
    private var batteryStatusLabel: NSTextField?
    
    public init() {
        super.init(window: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLanguageChanged), name: .languageChanged, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onLanguageChanged() {
        if self.window?.isVisible == true {
            rebuildUI()
        }
    }
    
    public func show() {
        AnalyticsManager.shared.trackPreferencesOpen()
        if self.window == nil {
            createPreferencesWindow()
        } else {
            rebuildUI()
        }
        updateBatteryLabel()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        self.window?.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func rebuildUI() {
        guard let window = self.window else { return }
        window.title = TR("preferences")
        let contentView = NSView(frame: window.contentRect(forFrameRect: window.frame))
        
        let tabView = NSTabView(frame: NSRect(x: 16, y: 16, width: 518, height: 448))
        
        let tabClamshell = NSTabViewItem(identifier: "clamshell")
        tabClamshell.label = TR("tab_clamshell")
        tabClamshell.view = createClamshellView(frame: tabView.bounds)
        tabView.addTabViewItem(tabClamshell)
        
        let tabBattery = NSTabViewItem(identifier: "battery")
        tabBattery.label = TR("tab_battery")
        tabBattery.view = createBatteryView(frame: tabView.bounds)
        tabView.addTabViewItem(tabBattery)
        
        let tabGeneral = NSTabViewItem(identifier: "general")
        tabGeneral.label = TR("tab_general")
        tabGeneral.view = createGeneralView(frame: tabView.bounds)
        tabView.addTabViewItem(tabGeneral)
        
        let tabAppearance = NSTabViewItem(identifier: "appearance")
        tabAppearance.label = TR("tab_appearance")
        tabAppearance.view = createAppearanceView(frame: tabView.bounds)
        tabView.addTabViewItem(tabAppearance)
        
        contentView.addSubview(tabView)
        window.contentView = contentView
        updateBatteryLabel()
    }
    
    private func createPreferencesWindow() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 550, height: 480),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = TR("preferences")
        window.isReleasedWhenClosed = false
        self.window = window
        rebuildUI()
    }
    
    // MARK: - Вкладка: Экран и Крышка
    private func createClamshellView(frame: NSRect) -> NSView {
        let view = NSView(frame: frame)
        var y: CGFloat = 345
        
        let cdmHeader = NSTextField(labelWithString: TR("clamshell_header"))
        cdmHeader.font = NSFont.boldSystemFont(ofSize: 13)
        cdmHeader.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(cdmHeader)
        y -= 28
        
        let chkPreventLid = NSButton(checkboxWithTitle: TR("clamshell_prevent"), target: self, action: #selector(togglePreventLid(_:)))
        chkPreventLid.state = settings.preventLidSleep ? .on : .off
        chkPreventLid.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkPreventLid)
        y -= 28
        
        let chkDimLid = NSButton(checkboxWithTitle: TR("clamshell_dim"), target: self, action: #selector(toggleDimLid(_:)))
        chkDimLid.state = settings.turnOffBacklightOnLidClose ? .on : .off
        chkDimLid.font = NSFont.systemFont(ofSize: 13, weight: .semibold)
        chkDimLid.frame = NSRect(x: 36, y: y, width: 460, height: 20)
        view.addSubview(chkDimLid)
        y -= 34
        
        let descDim = NSTextField(wrappingLabelWithString: TR("clamshell_dim_desc"))
        descDim.font = NSFont.systemFont(ofSize: 11)
        descDim.textColor = .secondaryLabelColor
        descDim.frame = NSRect(x: 36, y: y, width: 460, height: 32)
        view.addSubview(descDim)
        y -= 42
        
        let chkLockLid = NSButton(checkboxWithTitle: TR("clamshell_lock"), target: self, action: #selector(toggleLockLid(_:)))
        chkLockLid.state = settings.lockScreenOnLidClose ? .on : .off
        chkLockLid.frame = NSRect(x: 36, y: y, width: 460, height: 20)
        view.addSubview(chkLockLid)
        y -= 45
        
        let openHeader = NSTextField(labelWithString: TR("open_lid_header"))
        openHeader.font = NSFont.boldSystemFont(ofSize: 13)
        openHeader.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(openHeader)
        y -= 28
        
        let chkAllowDisplay = NSButton(checkboxWithTitle: TR("open_allow_sleep"), target: self, action: #selector(toggleAllowDisplay(_:)))
        chkAllowDisplay.state = settings.allowDisplaySleep ? .on : .off
        chkAllowDisplay.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkAllowDisplay)
        y -= 26
        
        let descAllow = NSTextField(wrappingLabelWithString: TR("open_allow_sleep_desc"))
        descAllow.font = NSFont.systemFont(ofSize: 11)
        descAllow.textColor = .secondaryLabelColor
        descAllow.frame = NSRect(x: 36, y: y, width: 460, height: 30)
        view.addSubview(descAllow)
        
        return view
    }
    
    // MARK: - Вкладка: Аккумулятор и Сеть
    private func createBatteryView(frame: NSRect) -> NSView {
        let view = NSView(frame: frame)
        var y: CGFloat = 345
        
        let battHeader = NSTextField(labelWithString: TR("battery_header"))
        battHeader.font = NSFont.boldSystemFont(ofSize: 13)
        battHeader.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(battHeader)
        y -= 28
        
        let chkLowBatt = NSButton(checkboxWithTitle: TR("battery_stop_thresh"), target: self, action: #selector(toggleLowBatt(_:)))
        chkLowBatt.state = settings.endSessionOnLowBattery ? .on : .off
        chkLowBatt.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkLowBatt)
        y -= 28
        
        let thresholdPopup = NSPopUpButton(frame: NSRect(x: 36, y: y, width: 140, height: 26), pullsDown: false)
        let thresholds = [5, 10, 15, 20, 25, 30, 40, 50]
        for t in thresholds {
            thresholdPopup.addItem(withTitle: "\(t)%")
        }
        thresholdPopup.selectItem(withTitle: "\(settings.lowBatteryThreshold)%")
        thresholdPopup.target = self
        thresholdPopup.action = #selector(thresholdChanged(_:))
        view.addSubview(thresholdPopup)
        y -= 30
        
        let chkAskLowBatt = NSButton(checkboxWithTitle: TR("battery_ask_first"), target: self, action: #selector(toggleAskLowBatt(_:)))
        chkAskLowBatt.state = settings.alwaysAskToEndOnLowBattery ? .on : .off
        chkAskLowBatt.frame = NSRect(x: 36, y: y, width: 460, height: 20)
        view.addSubview(chkAskLowBatt)
        y -= 26
        
        let chkIgnoreOnAC = NSButton(checkboxWithTitle: TR("battery_ignore_ac"), target: self, action: #selector(toggleIgnoreOnAC(_:)))
        chkIgnoreOnAC.state = settings.ignoreLowBatteryOnAC ? .on : .off
        chkIgnoreOnAC.frame = NSRect(x: 36, y: y, width: 460, height: 20)
        view.addSubview(chkIgnoreOnAC)
        y -= 38
        
        let acHeader = NSTextField(labelWithString: TR("ac_header"))
        acHeader.font = NSFont.boldSystemFont(ofSize: 13)
        acHeader.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(acHeader)
        y -= 28
        
        let chkStopOnDisconnect = NSButton(checkboxWithTitle: TR("ac_stop_unplug"), target: self, action: #selector(toggleStopOnDisconnect(_:)))
        chkStopOnDisconnect.state = settings.stopSessionOnACDisconnect ? .on : .off
        chkStopOnDisconnect.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkStopOnDisconnect)
        y -= 26
        
        let chkOnlyOnAC = NSButton(checkboxWithTitle: TR("ac_only_rule"), target: self, action: #selector(toggleOnlyOnAC(_:)))
        chkOnlyOnAC.state = settings.allowOnlyOnAC ? .on : .off
        chkOnlyOnAC.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkOnlyOnAC)
        y -= 26
        
        let chkStartOnAC = NSButton(checkboxWithTitle: TR("ac_autostart"), target: self, action: #selector(toggleStartOnAC(_:)))
        chkStartOnAC.state = settings.startSessionOnACConnect ? .on : .off
        chkStartOnAC.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkStartOnAC)
        y -= 36
        
        let statusBox = NSBox(frame: NSRect(x: 16, y: y - 10, width: 486, height: 40))
        statusBox.boxType = .custom
        statusBox.cornerRadius = 6
        statusBox.fillColor = NSColor.controlBackgroundColor
        statusBox.borderColor = NSColor.separatorColor
        
        let statusLabel = NSTextField(labelWithString: "Status...")
        statusLabel.font = NSFont.systemFont(ofSize: 12)
        statusLabel.frame = NSRect(x: 12, y: 10, width: 460, height: 20)
        statusBox.addSubview(statusLabel)
        view.addSubview(statusBox)
        self.batteryStatusLabel = statusLabel
        
        return view
    }
    
    // MARK: - Вкладка: Язык, Обновления и Аналитика
    private func createGeneralView(frame: NSRect) -> NSView {
        let view = NSView(frame: frame)
        var y: CGFloat = 345
        
        // Секция языка
        let langLabel = NSTextField(labelWithString: TR("lang_select"))
        langLabel.font = NSFont.boldSystemFont(ofSize: 13)
        langLabel.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(langLabel)
        y -= 30
        
        let langPopup = NSPopUpButton(frame: NSRect(x: 16, y: y, width: 220, height: 26), pullsDown: false)
        for lang in LocalizationManager.Language.allCases {
            langPopup.addItem(withTitle: lang.title)
        }
        langPopup.selectItem(withTitle: localization.selectedLanguage.title)
        langPopup.target = self
        langPopup.action = #selector(languageChanged(_:))
        view.addSubview(langPopup)
        y -= 38
        
        // Секция автозапуска при входе в macOS (Launch at Login)
        let chkLaunchAtLogin = NSButton(checkboxWithTitle: TR("launch_at_login"), target: self, action: #selector(toggleLaunchAtLogin(_:)))
        chkLaunchAtLogin.state = LaunchAtLoginHelper.isEnabled ? .on : .off
        chkLaunchAtLogin.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkLaunchAtLogin)
        y -= 38
        
        // Секция обновлений
        let updateHeader = NSTextField(labelWithString: TR("updates_header"))
        updateHeader.font = NSFont.boldSystemFont(ofSize: 13)
        updateHeader.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(updateHeader)
        y -= 28
        
        let chkAutoUpdates = NSButton(checkboxWithTitle: TR("auto_check_updates"), target: self, action: #selector(toggleAutoUpdates(_:)))
        chkAutoUpdates.state = updateManager.isAutoCheckEnabled ? .on : .off
        chkAutoUpdates.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkAutoUpdates)
        y -= 32
        
        let btnCheckUpdates = NSButton(title: TR("btn_check_now"), target: self, action: #selector(checkUpdatesClicked))
        btnCheckUpdates.frame = NSRect(x: 16, y: y, width: 220, height: 28)
        btnCheckUpdates.bezelStyle = .rounded
        view.addSubview(btnCheckUpdates)
        y -= 48
        
        // Секция аналитики и приватности
        let analHeader = NSTextField(labelWithString: TR("analytics_header"))
        analHeader.font = NSFont.boldSystemFont(ofSize: 13)
        analHeader.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(analHeader)
        y -= 28
        
        let chkAnalytics = NSButton(checkboxWithTitle: TR("allow_analytics"), target: self, action: #selector(toggleAnalytics(_:)))
        chkAnalytics.state = analytics.isEnabled ? .on : .off
        chkAnalytics.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkAnalytics)
        y -= 26
        
        let descAnal = NSTextField(wrappingLabelWithString: TR("analytics_desc"))
        descAnal.font = NSFont.systemFont(ofSize: 11)
        descAnal.textColor = .secondaryLabelColor
        descAnal.frame = NSRect(x: 36, y: y, width: 460, height: 32)
        view.addSubview(descAnal)
        
        return view
    }
    
    // MARK: - Вкладка: Внешний вид
    private func createAppearanceView(frame: NSRect) -> NSView {
        let view = NSView(frame: frame)
        var y: CGFloat = 345
        
        let iconLabel = NSTextField(labelWithString: TR("icon_style"))
        iconLabel.font = NSFont.boldSystemFont(ofSize: 13)
        iconLabel.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(iconLabel)
        y -= 32
        
        let iconPopup = NSPopUpButton(frame: NSRect(x: 16, y: y, width: 280, height: 26), pullsDown: false)
        for style in SettingsManager.IconStyle.allCases {
            iconPopup.addItem(withTitle: style.title)
        }
        iconPopup.selectItem(withTitle: settings.iconStyle.title)
        iconPopup.target = self
        iconPopup.action = #selector(iconPopupChanged(_:))
        view.addSubview(iconPopup)
        y -= 45
        
        let timerLabel = NSTextField(labelWithString: TR("show_timer"))
        timerLabel.font = NSFont.boldSystemFont(ofSize: 13)
        timerLabel.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(timerLabel)
        y -= 28
        
        let chkTimer = NSButton(checkboxWithTitle: TR("show_timer"), target: self, action: #selector(toggleShowTimer(_:)))
        chkTimer.state = settings.showTimerInMenuBar ? .on : .off
        chkTimer.frame = NSRect(x: 16, y: y, width: 480, height: 20)
        view.addSubview(chkTimer)
        
        return view
    }
    
    private func updateBatteryLabel() {
        batteryMonitor.updateCurrentState()
        let p = batteryMonitor.currentPercent
        let isAC = batteryMonitor.isACOnline
        let text = isAC ? String(format: TR("status_ac"), p) : String(format: TR("status_battery"), p)
        batteryStatusLabel?.stringValue = text
    }
    
    // MARK: - Обработчики
    @objc private func togglePreventLid(_ sender: NSButton) { settings.preventLidSleep = (sender.state == .on) }
    @objc private func toggleDimLid(_ sender: NSButton) { settings.turnOffBacklightOnLidClose = (sender.state == .on) }
    @objc private func toggleLockLid(_ sender: NSButton) { settings.lockScreenOnLidClose = (sender.state == .on) }
    @objc private func toggleAllowDisplay(_ sender: NSButton) { settings.allowDisplaySleep = (sender.state == .on) }
    @objc private func toggleShowTimer(_ sender: NSButton) { settings.showTimerInMenuBar = (sender.state == .on) }
    @objc private func toggleLowBatt(_ sender: NSButton) { settings.endSessionOnLowBattery = (sender.state == .on) }
    @objc private func toggleAskLowBatt(_ sender: NSButton) { settings.alwaysAskToEndOnLowBattery = (sender.state == .on) }
    @objc private func toggleIgnoreOnAC(_ sender: NSButton) { settings.ignoreLowBatteryOnAC = (sender.state == .on) }
    @objc private func toggleStopOnDisconnect(_ sender: NSButton) { settings.stopSessionOnACDisconnect = (sender.state == .on) }
    @objc private func toggleOnlyOnAC(_ sender: NSButton) { settings.allowOnlyOnAC = (sender.state == .on) }
    @objc private func toggleStartOnAC(_ sender: NSButton) { settings.startSessionOnACConnect = (sender.state == .on) }
    @objc private func toggleAutoUpdates(_ sender: NSButton) { updateManager.isAutoCheckEnabled = (sender.state == .on) }
    @objc private func toggleAnalytics(_ sender: NSButton) { analytics.isEnabled = (sender.state == .on) }
    @objc private func toggleLaunchAtLogin(_ sender: NSButton) { LaunchAtLoginHelper.isEnabled = (sender.state == .on) }
    
    @objc private func thresholdChanged(_ sender: NSPopUpButton) {
        let title = sender.titleOfSelectedItem ?? "10%"
        let numStr = title.replacingOccurrences(of: "%", with: "")
        if let val = Int(numStr) { settings.lowBatteryThreshold = val }
    }
    
    @objc private func languageChanged(_ sender: NSPopUpButton) {
        let title = sender.titleOfSelectedItem ?? ""
        if let lang = LocalizationManager.Language.allCases.first(where: { $0.title == title }) {
            localization.selectedLanguage = lang
        }
    }
    
    @objc private func iconPopupChanged(_ sender: NSPopUpButton) {
        let title = sender.titleOfSelectedItem ?? ""
        if let style = SettingsManager.IconStyle.allCases.first(where: { $0.title == title }) {
            settings.iconStyle = style
        }
    }
    
    @objc private func checkUpdatesClicked() {
        updateManager.checkForUpdates(manual: true)
    }
}
