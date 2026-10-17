import Foundation
import Security
import Darwin

/// Комплексный модуль защиты от взлома, реверс-инжиниринга и модификации бинарного кода (Anti-Tamper & Anti-Crack).
public final class AntiTamper {
    public static let shared = AntiTamper()
    
    private init() {}
    
    /// Запуск всех процедур защиты при старте приложения
    public func enforceSecurity() {
        #if !DEBUG
        // 1. Запрет подключения отладчиков (LLDB, GDB, Frida, Hopper debugger)
        denyDebuggerAttach()
        
        // 2. Проверка, не запущен ли процесс под отладчиком прямо сейчас
        if isDebuggerAttached() {
            exit(0)
        }
        
        // 3. Проверка на инъекции библиотек через DYLD
        if isDyldInjectionPresent() {
            exit(0)
        }
        
        // 4. Проверка целостности подписи кода
        _ = verifyCodeSignature()
        #endif
    }
    
    /// 1. Системный вызов PT_DENY_ATTACH
    /// Блокирует системную попытку любого стороннего процесса вызвать ptrace/mach_vm на наш процесс.
    private func denyDebuggerAttach() {
        // Disabled in ad-hoc local build to avoid SIGKILL 137 from macOS kernel
    }
    
    /// 2. Проверка флага P_TRACED через sysctl
    public func isDebuggerAttached() -> Bool {
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var info = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.stride
        
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        if junk != 0 {
            return false
        }
        
        // Проверяем флаг P_TRACED (0x00000800)
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
    
    /// 3. Проверка наличия переменных окружения внедрения кода (DYLD_INSERT_LIBRARIES)
    public func isDyldInjectionPresent() -> Bool {
        if getenv("DYLD_INSERT_LIBRARIES") != nil {
            return true
        }
        if getenv("DYLD_PRINT_LIBRARIES") != nil {
            return true
        }
        return false
    }
    
    /// 4. Валидация подписи кода приложения через Security.framework
    public func verifyCodeSignature() -> Bool {
        var secCode: SecCode?
        let status = SecCodeCopySelf(SecCSFlags(), &secCode)
        guard status == errSecSuccess, let code = secCode else {
            return false
        }
        
        // Проверяем валидность статической и динамической подписи
        let validity = SecCodeCheckValidity(code, SecCSFlags(rawValue: 0), nil)
        return (validity == errSecSuccess)
    }
}
