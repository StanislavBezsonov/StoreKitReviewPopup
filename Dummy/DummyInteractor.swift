import Foundation

protocol DummyBusinessLogic {
    func triggerReviewRequest()
}

class DummyInteractor {
    var presenter: DummyPresentationLogic?
    
    private let reviewService  = Services.reviewRequestService
}

extension DummyInteractor: DummyBusinessLogic {
    func triggerReviewRequest() {
        reviewService.requestReviewManually()
    }
}

