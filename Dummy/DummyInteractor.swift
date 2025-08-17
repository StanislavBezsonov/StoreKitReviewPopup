import Foundation

protocol DummyBusinessLogic {
    func load(request: DummyModels.Load.Request)
    func stopServices()
    func triggerReviewRequest()
}

class DummyInteractor {
    var presenter: DummyPresentationLogic?

    private let sessionService = Services.sessionTrackingService
    private let reviewService  = Services.reviewRequestService

    // MARK: - Настройка сервисов
    private func startServices() {
        reviewService.startMonitoring()
        presenter?.present(response: .init())
    }

    private func stopServicesInternal() {
        reviewService.stopMonitoring()
    }
}

extension DummyInteractor: DummyBusinessLogic {
    func load(request: DummyModels.Load.Request) {
        startServices()
    }

    func stopServices() {
        stopServicesInternal()
    }
    
    func triggerReviewRequest() {
        reviewService.requestReviewManually()
    }
}

