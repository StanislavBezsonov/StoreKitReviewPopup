import UIKit

protocol DummyDisplayLogic: AnyObject {
    func display(model: DummyModels.Load.ViewModel)
}

class DummyViewController: UIViewController {

    var interactor: DummyBusinessLogic?
    var router: DummyRoutingLogic?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        interactor?.load(request: .init())
        interactor?.triggerReviewRequest()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor?.stopServices()
    }

    func setupUI() {
        self.navigationItem.title = "Hello world!"
    }
}

extension DummyViewController: DummyDisplayLogic {
    func display(model: DummyModels.Load.ViewModel) {
    }
}
