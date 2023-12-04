//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by Maxim Makarov on 02.12.2023.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet var animalTypeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var answersChoosen: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension ResultViewController {
    
    private func getResult() {
        var repeatabilityOfAnimals: [Animal: Int] = [:]
        let animals = answersChoosen.map { $0.animal }
        
        for animal in animals {
            if let animalTypeCount = repeatabilityOfAnimals[animal] {
                repeatabilityOfAnimals.updateValue(animalTypeCount + 1, forKey: animal)
            } else {
                repeatabilityOfAnimals[animal] = 1
            }
        }
        
        let sortedRepeatabilityOfAnimals = repeatabilityOfAnimals.sorted { $0.value > $1.value }
        guard let mostRepetitiveAnimal = sortedRepeatabilityOfAnimals.first?.key else { return }
    }
    
}
