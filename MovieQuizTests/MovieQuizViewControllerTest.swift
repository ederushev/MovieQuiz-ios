//
//  MovieQuizViewControllerTest.swift
//  MovieQuizViewControllerTest
//
//  Created by Эдуард Дерюшев on 07.02.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func showLoadingIndicator() {
        
    }
    
    func buttonOff() {
     
    }
    

    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer isCorrect: Bool) {
        
    }
    
    func setupActivityIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    var activityIndicator: UIActivityIndicatorView!
    
    func showNetworkError(with message: String) {
        
    }
    
    func showEndGameAlert() {
        
    }
}

final class MovieQUizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
