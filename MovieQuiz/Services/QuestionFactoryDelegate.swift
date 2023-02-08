//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Эдуард Дерюшев on 05.01.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
//    func showNetworkError(with message: String)
}
