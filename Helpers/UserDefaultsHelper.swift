import Foundation

enum UserDefaultsHelper {
    private static let defaults = UserDefaults.standard

    private enum Keys {
        static let firstLaunchDate = "firstLaunchDate"
        static let lastReviewRequestDate = "lastReviewRequestDate"
        static let completedSessions = "completedSessions"
        static let totalUsage = "totalUsage"
        static let lastSessionEnd = "lastSessionEnd"
        static let usageUntilNotification = "usageUntilNotification"
        static let usageCheckpoint = "review_usage_checkpoint"
    }
    
    // MARK: - Convenience accessors
    static var firstLaunchDate: Date? {
        get { getDate(for: Keys.firstLaunchDate) }
        set { set(newValue, for: Keys.firstLaunchDate) }
    }

    static var lastReviewRequestDate: Date? {
        get { getDate(for: Keys.lastReviewRequestDate) }
        set { set(newValue, for: Keys.lastReviewRequestDate) }
    }

    static var completedSessions: Int {
        get { getInt(for: Keys.completedSessions) }
        set { set(newValue, for: Keys.completedSessions) }
    }

    static var totalUsage: TimeInterval {
        get { getTimeInterval(for: Keys.totalUsage) ?? 0 }
        set { set(newValue, for: Keys.totalUsage) }
    }

    static var lastSessionEnd: Date? {
        get { getDate(for: Keys.lastSessionEnd) }
        set { set(newValue, for: Keys.lastSessionEnd) }
    }

    static var usageCheckpoint: TimeInterval {
        get { getTimeInterval(for: Keys.usageCheckpoint) ?? 0 }
        set { set(newValue, for: Keys.usageCheckpoint) }
    }

    // MARK: - Base methods    
    private static func set(_ value: Any?, for key: String) {
        defaults.set(value, forKey: key)
    }
    
    private static func getDate(for key: String) -> Date? {
        return defaults.object(forKey: key) as? Date
    }
    
    private static func getInt(for key: String) -> Int {
        return defaults.integer(forKey: key)
    }
    
    private static func getTimeInterval(for key: String) -> TimeInterval? {
        let value = defaults.double(forKey: key)
        return value == 0 ? nil : value
    }
}
