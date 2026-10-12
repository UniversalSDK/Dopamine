import Foundation

/// Traps process signals (SIGINT, SIGTERM, SIGHUP) to ensure sleep settings and display backlight are restored.
public final class SignalLifecycleManager {
    public static let shared = SignalLifecycleManager()
    
    private var signalSources: [DispatchSourceSignal] = []
    private let queue = DispatchQueue(label: "com.amphetamineplus.lifecycle.signals")
    private var isInstalled = false
    
    public init() {}
    
    public func install(onShutdown: @escaping () -> Void) {
        guard !isInstalled else { return }
        isInstalled = true
        
        let signals = [SIGINT, SIGTERM, SIGHUP]
        for sig in signals {
            signal(sig, SIG_IGN)
            let source = DispatchSource.makeSignalSource(signal: sig, queue: queue)
            source.setEventHandler {
                NSLog("[SignalLifecycleManager] Received signal %d. Restoring display and system power state...", sig)
                onShutdown()
                exit(0)
            }
            source.resume()
            signalSources.append(source)
        }
    }
}
