import StoreKit
import Foundation

final class ReviewRequestService {
    private let minSessions = 2
    private let minUsage: TimeInterval = 10 * 60
    private let cooldownDays: TimeInterval = 3 * 24 * 60 * 60

    private let trackingService: SessionTrackingServiceProtocol
    private var usageTimer: Timer?
    private var isReviewBeingShown = false

    private let userDefaults = UserDefaultsHelper.shared

    // MARK: - Init
    init(trackingService: SessionTrackingServiceProtocol) {
        self.trackingService = trackingService

        if userDefaults.firstLaunchDate == nil {
            userDefaults.firstLaunchDate = Date()
        }
        if userDefaults.lastReviewRequestDate == nil {
            userDefaults.lastReviewRequestDate = userDefaults.firstLaunchDate
        }
    }

    // MARK: - Public API
    func startMonitoring() {
        evaluateSingleTimeConditions()
        startUsageTimerIfNeeded()
        evaluateUsageTime()
        setupNotifications()
    }

    func stopMonitoring() {
        print("ReviewRequestService: остановка мониторинга")
        stopUsageTimer()
    }

    // MARK: - Conditions
    func hasEnoughSessions(completedSessions: Int) {
        print("ReviewRequestService: завершённых сессий = \(completedSessions) / нужно ≥ \(minSessions)")
        if completedSessions >= minSessions {
            requestReview()
        }
    }

    func hasEnoughUsageTime(usageTime: TimeInterval) {
        let checkpoint = userDefaults.usageCheckpoint
        let delta = usageTime - checkpoint
        print("ReviewRequestService: прирост использования = \(Int(delta)) сек / нужно ≥ \(Int(minUsage)) сек (чекпойнт: \(Int(checkpoint)) сек, текущее: \(Int(usageTime)) сек)")

        if delta >= minUsage {
            requestReview()
        }
    }

    func hasEnoughCooldownPassed() {
        let last = userDefaults.lastReviewRequestDate ?? .distantPast
        let enoughTime = Date().timeIntervalSince(last) >= cooldownDays
        print("ReviewRequestService: проверка cooldown — прошло \(Int(Date().timeIntervalSince(last))) сек, требуется ≥ \(Int(cooldownDays)) сек. Пройден: \(enoughTime)")
        if enoughTime {
            requestReview()
        }
    }

    // MARK: - Internal
    private func evaluateUsageTime() {
        let usage = trackingService.currentSessionDuration
        hasEnoughUsageTime(usageTime: usage)
    }
    
    private func evaluateSingleTimeConditions() {
        let sessions = trackingService.completedSessions
        hasEnoughSessions(completedSessions: sessions)
        hasEnoughCooldownPassed()
    }

    // MARK: - Request    
    func requestReviewManually() {
        requestReview()
    }
    
    private func requestReview() {
        guard !isReviewBeingShown else {
            return
        }

        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        isReviewBeingShown = true
        SKStoreReviewController.requestReview(in: scene)

        // чтобы не накладывалось окно отзыва поверх уже вызванного
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.isReviewBeingShown = false
        }

        userDefaults.lastReviewRequestDate = Date()
        userDefaults.usageCheckpoint = trackingService.currentSessionDuration
    }
}

// MARK: - Timer
private extension ReviewRequestService {

    func startUsageTimerIfNeeded() {
        guard usageTimer == nil else {
            return
        }
        usageTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.evaluateUsageTime()
        }
        if let usageTimer {
            RunLoop.main.add(usageTimer, forMode: .common)
        }
    }

    func stopUsageTimer() {
        usageTimer?.invalidate()
        usageTimer = nil
    }
}

private extension ReviewRequestService {

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

    @objc func appWillEnterForeground() {
        startUsageTimerIfNeeded()
        evaluateSingleTimeConditions()
    }

    @objc func appDidEnterBackground() {
        stopUsageTimer()
    }
}
