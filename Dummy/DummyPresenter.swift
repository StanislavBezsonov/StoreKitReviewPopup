//
//  DummyPresenter.swift
//  iOS-Test
//

// Implemented by View layer (ViewControllers)
protocol DummyPresentationLogic {
  func present(response: DummyModels.Load.Response)
}

class DummyPresenter {
  weak var view: DummyDisplayLogic?
}

extension DummyPresenter: DummyPresentationLogic {
  // Transforms Load.Response into ViewModel to be displayed by the ViewController
  func present(response: DummyModels.Load.Response) {
    view?.display(model: .init())
  }
}
