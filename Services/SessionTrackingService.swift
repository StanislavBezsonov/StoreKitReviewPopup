import UIKit

protocol SessionTrackingServiceProtocol: AnyObject {
    var completedSessions: Int { get }
    var totalSessionsDuration: TimeInterval { get }
    var currentSessionDuration: TimeInterval { get }
}

final class SessionTrackingService: SessionTrackingServiceProtocol {
    private let sessionTimeout: TimeInterval = 60 * 60

    private var sessionStart: Date?
    private(set) var completedSessions: Int = 0
    private(set) var totalSessionsDuration: TimeInterval = 0

    var currentSessionDuration: TimeInterval {
        if let start = sessionStart {
            return totalSessionsDuration + Date().timeIntervalSince(start)
        } else {
            return totalSessionsDuration
        }
    }
    
    // MARK: - Init
    init() {
        totalSessionsDuration = UserDefaultsHelper.totalUsage
        completedSessions = UserDefaultsHelper.completedSessions
    }

    // MARK: - Session
    func startSession() {
        let now = Date()
        guard sessionStart == nil else {
            return
        }

        if let lastEnd = UserDefaultsHelper.lastSessionEnd {
            let interval = now.timeIntervalSince(lastEnd)
            if interval > sessionTimeout {
                completedSessions += 1
                UserDefaultsHelper.completedSessions = completedSessions
                print("Начата НОВАЯ сессия (timeout превышен). Всего завершённых: \(completedSessions)")
            } else {
                print("Продолжаем прошлую сессию (timeout не превышен)")
            }
        } else {
            completedSessions += 1
            UserDefaultsHelper.completedSessions = completedSessions
        }

        sessionStart = now
        
        setupNotifications()
    }

    private func saveCurrentSession() {
        guard let start = sessionStart else {
            return
        }
        let now = Date()
        let duration = now.timeIntervalSince(start)

        totalSessionsDuration += duration
        UserDefaultsHelper.totalUsage = totalSessionsDuration
        UserDefaultsHelper.lastSessionEnd = now
    }
}

private extension SessionTrackingService {
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc private func appWillEnterForeground() {
        startSession()
    }
    
    @objc private func appDidEnterBackground() {
        saveCurrentSession()
        sessionStart = nil
    }
}
