import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    var activityIndicator: UIActivityIndicatorView! { get set }
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func showNetworkError(with message: String)
    func buttonOff()
}

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers: Int = 0

    var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
    super.viewDidLoad()
     //   alertPresenter = AlertPresenter(delegate: sef)
        showLoadingIndicator()
        questionFactory?.loadData()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    func showLoadingIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
   
    func showNetworkError(with message: String) {
        hideLoadingIndicator()

        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)

            let action = UIAlertAction(title: "Попробовать ещё раз",
            style: .default) { [weak self] _ in
                guard let self = self else { return }

                self.presenter.restartGame()
            }

        alert.addAction(action)
    
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

//    func show(quiz result: QuizResultsViewModel) {
//        let message = presenter.makeResultsMessage()
//
//        let alert = UIAlertController(
//            title: result.title,
//            message: message,
//            preferredStyle: .alert)
//
//            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
//                guard let self = self else { return }
//
//                self.presenter.restartGame()
//            }
//        alert.addAction(action)
//
//        self.present(alert, animated: true, completion: nil)
//    }

    
    @IBAction private func noButtonClicked(_ sender: UIButton) {

        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {

        presenter.yesButtonClicked()
    }

    func buttonOff () {
        self.noButton.isEnabled.toggle()
        self.yesButton.isEnabled.toggle()
    }
}
