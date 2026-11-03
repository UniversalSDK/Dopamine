import AppKit

/// Контроллер нативных диалоговых окон для настройки таймера сессий в стиле Amphetamine.
public final class TimerDialogController: NSObject {
    public static let shared = TimerDialogController()
    
    private var hoursField: NSTextField?
    private var minutesField: NSTextField?
    private var hoursStepper: NSStepper?
    private var minutesStepper: NSStepper?
    private var quitCheckbox: NSButton?
    private var datePicker: NSDatePicker?
    
    // MARK: - Диалог: Свой таймер (Часы + Минуты + Пресеты)
    public func showCustomTimerDialog(initialSeconds: Int? = nil, onConfirm: @escaping (Int, Bool) -> Void) {
        let alert = NSAlert()
        alert.messageText = "⏱ " + TR("custom_timer_title")
        alert.informativeText = TR("custom_timer_prompt")
        alert.alertStyle = .informational
        alert.addButton(withTitle: TR("btn_start_timer"))
        alert.addButton(withTitle: TR("btn_cancel"))
        
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 330, height: 120))
        
        let initialHours: Int
        let initialMinutes: Int
        if let sec = initialSeconds, sec > 0 {
            initialHours = sec / 3600
            initialMinutes = (sec % 3600) / 60
        } else {
            initialHours = 1
            initialMinutes = 0
        }
        
        // Часы
        let hLabel = NSTextField(labelWithString: TR("hours_label"))
        hLabel.frame = NSRect(x: 10, y: 82, width: 70, height: 20)
        hLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        container.addSubview(hLabel)
        
        let hField = NSTextField(frame: NSRect(x: 85, y: 80, width: 50, height: 24))
        hField.stringValue = "\(initialHours)"
        hField.alignment = .center
        hField.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .semibold)
        container.addSubview(hField)
        self.hoursField = hField
        
        let hStep = NSStepper(frame: NSRect(x: 138, y: 80, width: 19, height: 24))
        hStep.minValue = 0
        hStep.maxValue = 99
        hStep.integerValue = initialHours
        hStep.target = self
        hStep.action = #selector(hoursStepperChanged(_:))
        container.addSubview(hStep)
        self.hoursStepper = hStep
        
        // Минуты
        let mLabel = NSTextField(labelWithString: TR("minutes_label"))
        mLabel.frame = NSRect(x: 175, y: 82, width: 70, height: 20)
        mLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        container.addSubview(mLabel)
        
        let mField = NSTextField(frame: NSRect(x: 250, y: 80, width: 50, height: 24))
        mField.stringValue = "\(initialMinutes)"
        mField.alignment = .center
        mField.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .semibold)
        container.addSubview(mField)
        self.minutesField = mField
        
        let mStep = NSStepper(frame: NSRect(x: 303, y: 80, width: 19, height: 24))
        mStep.minValue = 0
        mStep.maxValue = 59
        mStep.integerValue = initialMinutes
        mStep.target = self
        mStep.action = #selector(minutesStepperChanged(_:))
        container.addSubview(mStep)
        self.minutesStepper = mStep
        
        // Быстрые кнопки пресетов (15m, 30m, 45m, 1h, 2h, 4h)
        let presets: [(Int, String)] = [(15, "15m"), (30, "30m"), (45, "45m"), (60, "1h"), (120, "2h"), (240, "4h")]
        var px: CGFloat = 10
        for (mins, label) in presets {
            let btn = NSButton(title: label, target: self, action: #selector(presetClicked(_:)))
            btn.bezelStyle = .rounded
            btn.tag = mins
            btn.font = NSFont.systemFont(ofSize: 11)
            btn.frame = NSRect(x: px, y: 44, width: 48, height: 24)
            container.addSubview(btn)
            px += 52
        }
        
        // Чекбокс: Закрывать Dopamine по окончании таймера
        let chk = NSButton(checkboxWithTitle: TR("quit_app_on_session_end"), target: self, action: #selector(quitCheckboxToggled(_:)))
        chk.frame = NSRect(x: 10, y: 12, width: 310, height: 20)
        chk.state = SettingsManager.shared.quitAppOnSessionEnd ? .on : .off
        container.addSubview(chk)
        self.quitCheckbox = chk
        
        alert.accessoryView = container
        NSApp.activate(ignoringOtherApps: true)
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            let h = max(0, Int(hField.stringValue) ?? hStep.integerValue)
            let m = max(0, Int(mField.stringValue) ?? mStep.integerValue)
            let total = (h * 3600) + (m * 60)
            if total > 0 {
                SettingsManager.shared.quitAppOnSessionEnd = (chk.state == .on)
                onConfirm(total, chk.state == .on)
            }
        }
    }
    
    // MARK: - Диалог: До определенного времени (Time Picker)
    public func showUntilTimeDialog(onConfirm: @escaping (Int, Bool) -> Void) {
        let alert = NSAlert()
        alert.messageText = "🕒 " + TR("until_time_title")
        alert.informativeText = TR("until_time_prompt")
        alert.alertStyle = .informational
        alert.addButton(withTitle: TR("btn_start_timer"))
        alert.addButton(withTitle: TR("btn_cancel"))
        
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 320, height: 80))
        
        let picker = NSDatePicker(frame: NSRect(x: 95, y: 45, width: 130, height: 28))
        picker.datePickerStyle = .textFieldAndStepper
        picker.datePickerElements = [.hourMinute]
        picker.dateValue = Date().addingTimeInterval(3600) // По умолчанию +1 час
        container.addSubview(picker)
        self.datePicker = picker
        
        let chk = NSButton(checkboxWithTitle: TR("quit_app_on_session_end"), target: self, action: #selector(quitCheckboxToggled(_:)))
        chk.frame = NSRect(x: 10, y: 12, width: 300, height: 20)
        chk.state = SettingsManager.shared.quitAppOnSessionEnd ? .on : .off
        container.addSubview(chk)
        self.quitCheckbox = chk
        
        alert.accessoryView = container
        NSApp.activate(ignoringOtherApps: true)
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            let targetDate = picker.dateValue
            let now = Date()
            let cal = Calendar.current
            let comp = cal.dateComponents([.hour, .minute], from: targetDate)
            
            if var computed = cal.date(bySettingHour: comp.hour ?? 0, minute: comp.minute ?? 0, second: 0, of: now) {
                if computed <= now {
                    computed = cal.date(byAdding: .day, value: 1, to: computed) ?? computed
                }
                let total = max(60, Int(computed.timeIntervalSince(now)))
                SettingsManager.shared.quitAppOnSessionEnd = (chk.state == .on)
                onConfirm(total, chk.state == .on)
            }
        }
    }
    
    @objc private func hoursStepperChanged(_ sender: NSStepper) {
        hoursField?.stringValue = "\(sender.integerValue)"
    }
    
    @objc private func minutesStepperChanged(_ sender: NSStepper) {
        minutesField?.stringValue = "\(sender.integerValue)"
    }
    
    @objc private func presetClicked(_ sender: NSButton) {
        let mins = sender.tag
        let h = mins / 60
        let m = mins % 60
        hoursStepper?.integerValue = h
        hoursField?.stringValue = "\(h)"
        minutesStepper?.integerValue = m
        minutesField?.stringValue = "\(m)"
    }
    
    @objc private func quitCheckboxToggled(_ sender: NSButton) {
        SettingsManager.shared.quitAppOnSessionEnd = (sender.state == .on)
    }
}
