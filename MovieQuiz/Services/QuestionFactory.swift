//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Эдуард Дерюшев on 03.01.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
           
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
   
        
            }
            let randomCompare = Bool.random()
            let rating = Float(movie.rating) ?? 0
            var text = ""
            var correctAnswer = false
            if rating <= Float(5) {
                let randomRating = Int.random(in: 3...5)
                if randomCompare {
                        text = "Рейтинг этого фильма больше чем \(randomRating)?"
                        correctAnswer = rating > Float(randomRating)
                }
                else {  text = "Рейтинг этого фильма меньше чем \(randomRating)?"
                        correctAnswer = rating < Float(randomRating)
                }
            } else if rating >= Float(5) && rating <= Float(7) {
                let randomRating = Int.random(in: 5...7)
                if randomCompare {
                        text = "Рейтинг этого фильма больше чем \(randomRating)?"
                        correctAnswer = rating > Float(randomRating)
                }
                else {  text = "Рейтинг этого фильма меньше чем \(randomRating)?"
                        correctAnswer = rating < Float(randomRating)
                }
            } else if rating > Float(7) { let randomRating = Int.random(in: 7...9)
                if randomCompare {
                        text = "Рейтинг этого фильма больше чем \(randomRating)?"
                        correctAnswer = rating > Float(randomRating)
                }
                else {  text = "Рейтинг этого фильма меньше чем \(randomRating)?"
                        correctAnswer = rating < Float(randomRating)
                }
            }
        
            let question = QuizQuestion(image: imageData,
                                         text: text,
                                         correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
}
