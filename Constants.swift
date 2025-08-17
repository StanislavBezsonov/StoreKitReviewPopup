import Foundation

struct Constants {
    // MARK: - Session Tracking
    static let sessionTimeout: TimeInterval = 60 * 60
    
    // MARK: - Review Request
    static let minSessionsForReview = 2
    static let usageThresholdForReview: TimeInterval = 10 * 60
    static let cooldownForReview: TimeInterval = 3 * 24 * 60 * 60
}
