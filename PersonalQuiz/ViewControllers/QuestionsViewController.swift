//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by Maxim Makarov on 02.12.2023.
//

import UIKit

final class QuestionsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var questionProgressView: UIProgressView!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet var rangedSlider: UISlider!
    
    // MARK: - Private Properties
    private var questionIndex = 0 // Объявили общий индекс, от которого будем отталкиваться
    private let questions = Question.getQuestions()
    private var answersChosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answers
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        let answersCount = Float(currentAnswers.count - 1)
        rangedSlider.maximumValue = answersCount
        rangedSlider.value = answersCount / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultsViewController = segue.destination as? ResultViewController else {
            return
        }
        resultsViewController.answersChosen = answersChosen
    }
    
    // MARK: - IB Actions
    @IBAction func singleQuestionButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else { return }
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)
        nextQuestion()
    }
    
    @IBAction func multipleQuestionButtonPressed() {
        for (multipleSwitch, answer) in zip(multipleSwitches, currentAnswers) {
            if multipleSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedQuestionButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswers[index])
        nextQuestion()
    }
}
    
// MARK: - IB Actions
private extension QuestionsViewController {
    func updateUI() {
        // Hide everything
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            stackView?.isHidden = true
        }
        
        // Set navigation title
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        // Get current question
        let currentQuestion = questions[questionIndex]
        
        // Set current question for label
        questionLabel.text = currentQuestion.title
        
        // Calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // Set progress for progressQuestionView
        questionProgressView.setProgress(totalProgress, animated: true)
        
        showCurrentAnswers(for: currentQuestion.type)
    }
    
    /// Choise of answers category
    ///
    /// Displaying answers to a question according to a category
    ///
    /// - Parameter type: Specifies the category of response
    func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStackView(with: currentAnswers)
        case .mupltiple: showMultipleStackView(with: currentAnswers)
        case .ranged: showRangedStackView(with: currentAnswers)
        }
    }
    
    func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    func showMultipleStackView(with answers: [Answer]) {
        multipleStackView.isHidden.toggle()
        
        for (label, anser) in zip(multipleLabels, answers) {
            label.text = anser.title
        }
    }
    
    func showRangedStackView(with answers: [Answer]) {
        rangedStackView.isHidden.toggle()
        
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        // Делаем программный переход
        performSegue(withIdentifier: "showResult", sender: nil)
        
    }
}

