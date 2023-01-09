import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    private var correctAnswers: Int = 0
    private var currentQuestionIndex = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        questionFactory?.requestNextQuestion()
        statisticService = StatisticServiceImplementation()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
        imageView.layer.borderWidth = 0
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        yesButton.isEnabled.toggle()
        noButton.isEnabled.toggle()
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        yesButton.isEnabled.toggle()
        noButton.isEnabled.toggle()
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.cornerRadius = 20
        if isCorrect {
            correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            
        }
        else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        yesButton.isEnabled.toggle()
        noButton.isEnabled.toggle()
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
                       statisticService.store(correct: correctAnswers, total: questionsAmount)

            let totalAccuracyPercentage = String(format: "%.2f", statisticService.totalAccuracy * 100) + "%"
            let localizedTime = statisticService.bestGame.date.dateTimeString
            let bestGameStats = "\(statisticService.bestGame.correct)/\(statisticService.bestGame.total)"

            let text =
                       """
                       Ваш результат: \(correctAnswers)/\(questionsAmount)
                       Количество сыгранных квизов: \(statisticService.gamesCount)
                       Рекорд: \(bestGameStats) (\(localizedTime))
                       Средняя точность: \(totalAccuracyPercentage)
                       """
            //let text = "Ваш результат: \(correctAnswers) из 10"
            let alert = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть еще раз") { [weak self] in
                guard let self = self else { return }

                self.currentQuestionIndex = 0 // сброс счета
                self.correctAnswers = 0

                self.questionFactory?.requestNextQuestion()  // заново показываем первый вопрос
            }


            alertPresenter?.showAlert(model: alert)
            
        } else {
            
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {
            [weak self] in guard let self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.imageView.layer.borderWidth = 0
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.showAlert(model: alertModel)
    }
}
