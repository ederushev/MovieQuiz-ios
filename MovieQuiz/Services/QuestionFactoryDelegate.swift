//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Эдуард Дерюшев on 05.01.2023.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    
}
