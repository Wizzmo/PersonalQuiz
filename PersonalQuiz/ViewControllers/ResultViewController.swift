//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Maxim Makarov on 02.12.2023.
//

import UIKit

final class ResultViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var animalTypeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var answers: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        getResult()
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension ResultViewController {
    
    private func getResult() {
        var repeatabilityOfAnimals: [Animal: Int] = [:]
        let animals = answers.map { $0.animal }
        
        for animal in animals {
            if let animalTypeCount = repeatabilityOfAnimals[animal] {
                repeatabilityOfAnimals.updateValue(animalTypeCount + 1, forKey: animal)
            } else {
                repeatabilityOfAnimals[animal] = 1
            }
        }
        
        let sortedRepeatabilityOfAnimals = repeatabilityOfAnimals.sorted { $0.value > $1.value }
        guard let mostRepetitiveAnimal = sortedRepeatabilityOfAnimals.first?.key else { return }
        
        updateScreen(with: mostRepetitiveAnimal)
    }
    
    private func updateScreen(with animal: Animal?) {
        animalTypeLabel.text = "Вы - \(animal?.rawValue ?? "🐙")!"
        descriptionLabel.text = animal?.definition ?? ""
    }
}
