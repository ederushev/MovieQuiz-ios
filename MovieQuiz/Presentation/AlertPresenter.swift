//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Эдуард Дерюшев on 05.01.2023.
//

import UIKit

protocol AlertPresenterProtocol {
    
}

class AlertPresenter {
    
    weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showQuizResult(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: model.buttonText,
            style: .default) { _ in
                model.completion()}
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
        alert.view.accessibilityIdentifier = "alert"
    }
}
