struct Services {
    static let sessionTrackingService = SessionTrackingService()
    static let reviewRequestService = ReviewRequestService(trackingService: sessionTrackingService)
}
